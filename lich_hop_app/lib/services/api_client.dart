import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Cấu hình địa chỉ máy chủ backend Django.
///
/// Đổi [baseUrl] thành địa chỉ thật khi triển khai lên server/VM chính thức
/// (ví dụ https://api.lichhop.gov.vn/api). Mặc định trỏ vào máy chủ Django
/// chạy cục bộ để phát triển/kiểm thử.
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => message;
}

/// Client HTTP dùng chung cho toàn app: tự đính JWT, tự làm mới token khi hết hạn,
/// lưu token vào SharedPreferences (localStorage trên web) để giữ phiên đăng nhập.
class ApiClient {
  static const _kAccess = 'lh_access_token';
  static const _kRefresh = 'lh_refresh_token';

  String? _access;
  String? _refresh;

  Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _access = prefs.getString(_kAccess);
    _refresh = prefs.getString(_kRefresh);
  }

  bool get hasSession => _access != null;

  Future<void> _saveTokens({String? access, String? refresh}) async {
    final prefs = await SharedPreferences.getInstance();
    if (access != null) {
      _access = access;
      await prefs.setString(_kAccess, access);
    }
    if (refresh != null) {
      _refresh = refresh;
      await prefs.setString(_kRefresh, refresh);
    }
  }

  Future<void> clearSession() async {
    _access = null;
    _refresh = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccess);
    await prefs.remove(_kRefresh);
  }

  Uri _u(String path, [Map<String, dynamic>? query]) {
    final clean = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('${ApiConfig.baseUrl}/$clean').replace(
      queryParameters:
          query?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Map<String, String> _headers({bool json = true}) => {
        if (json) 'Content-Type': 'application/json',
        if (_access != null) 'Authorization': 'Bearer $_access',
      };

  Future<bool> login(String email, String password) async {
    final res = await http.post(
      _u('auth/login/'),
      headers: _headers(),
      body: jsonEncode({'username': email, 'password': password}),
    );
    if (res.statusCode != 200) return false;
    final body = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    await _saveTokens(access: body['access'] as String, refresh: body['refresh'] as String);
    return true;
  }

  Future<void> logout() => clearSession();

  Future<bool> _tryRefresh() async {
    if (_refresh == null) return false;
    final res = await http.post(
      _u('auth/refresh/'),
      headers: _headers(),
      body: jsonEncode({'refresh': _refresh}),
    );
    if (res.statusCode != 200) return false;
    final body = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    await _saveTokens(access: body['access'] as String);
    return true;
  }

  Future<dynamic> _send(String method, String path,
      {Map<String, dynamic>? body, Map<String, dynamic>? query}) async {
    Future<http.Response> doRequest() {
      final uri = _u(path, query);
      final encodedBody = body == null ? null : jsonEncode(body);
      switch (method) {
        case 'GET':
          return http.get(uri, headers: _headers());
        case 'POST':
          return http.post(uri, headers: _headers(), body: encodedBody);
        case 'PATCH':
          return http.patch(uri, headers: _headers(), body: encodedBody);
        case 'DELETE':
          return http.delete(uri, headers: _headers());
        default:
          throw ArgumentError('method khong ho tro: $method');
      }
    }

    var res = await doRequest();
    if (res.statusCode == 401 && await _tryRefresh()) {
      res = await doRequest();
    }
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    String message = 'Lỗi máy chủ (${res.statusCode})';
    try {
      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      message = decoded.toString();
    } catch (_) {}
    throw ApiException(res.statusCode, message);
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send('GET', path, query: query);
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) =>
      _send('POST', path, body: body);
  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) =>
      _send('PATCH', path, body: body);
  Future<dynamic> delete(String path) => _send('DELETE', path);

  /// Tải file thật lên server (multipart) — dùng cho tính năng đính kèm
  /// tài liệu thật (thay cho bản mô phỏng cũ chỉ random tên file mẫu).
  Future<dynamic> uploadFile(
    String path, {
    required Uint8List bytes,
    required String filename,
    Map<String, String>? fields,
  }) async {
    Future<http.StreamedResponse> doRequest() {
      final req = http.MultipartRequest('POST', _u(path));
      req.headers.addAll(_headers(json: false));
      if (fields != null) req.fields.addAll(fields);
      req.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
      return req.send();
    }

    var streamed = await doRequest();
    if (streamed.statusCode == 401 && await _tryRefresh()) {
      streamed = await doRequest();
    }
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(utf8.decode(res.bodyBytes));
    }
    String message = 'Lỗi máy chủ (${res.statusCode})';
    try {
      final decoded = jsonDecode(utf8.decode(res.bodyBytes));
      message = decoded.toString();
    } catch (_) {}
    throw ApiException(res.statusCode, message);
  }
}

final api = ApiClient();
