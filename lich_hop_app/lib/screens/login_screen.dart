import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _passFocus = FocusNode();
  bool _submitting = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final loginValue = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    if (loginValue.isEmpty || password.isEmpty) {
      showToast(context, 'Vui lòng nhập tên đăng nhập/email và mật khẩu',
          type: NoticeType.warn);
      return;
    }
    setState(() => _submitting = true);
    final ok = await AppScope.read(context).login(loginValue, password);
    if (!mounted) return;
    setState(() => _submitting = false);
    if (!ok) {
      showToast(context, AppScope.read(context).authError ?? 'Đăng nhập thất bại',
          type: NoticeType.warn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.navy, AppColors.green],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x2E000000),
                          blurRadius: 32,
                          offset: Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.account_balance,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(height: 10),
                      const Text('Hệ thống Quản lý Lịch họp',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.5, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 3),
                      const Text('Ủy ban nhân dân – Đăng nhập tài khoản thật',
                          style:
                              TextStyle(fontSize: 11.5, color: AppColors.tm)),
                      const SizedBox(height: 22),
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Tên đăng nhập hoặc email',
                          prefixIcon: Icon(Icons.person_outline, size: 18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passCtrl,
                        focusNode: _passFocus,
                        obscureText: true,
                        onSubmitted: (_) => _login(),
                        decoration: const InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: Icon(Icons.lock_outline, size: 18),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          _submitting ? 'Đang đăng nhập...' : 'Đăng nhập',
                          icon: Icons.login,
                          onPressed: _submitting ? null : _login,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nhập tên đăng nhập/email và mật khẩu tài khoản của bạn',
                        style: TextStyle(fontSize: 11.5, color: AppColors.tm),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
