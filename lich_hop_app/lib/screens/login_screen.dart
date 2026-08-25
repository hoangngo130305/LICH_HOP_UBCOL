import 'package:flutter/material.dart';

import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

String _demoEmail(UserRole role) => switch (role) {
      UserRole.lanhDao => 'lanhdao@caungolanh.gov.vn',
      UserRole.vanThu => 'vanthu.ubnd@caungolanh.gov.vn',
      UserRole.quanTri => 'superadmin@caungolanh.gov.vn',
      UserRole.phongBan => 'vanthu.vanphong@caungolanh.gov.vn',
      UserRole.thanhVien => 'canbo@caungolanh.gov.vn',
    };

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole? _selected;
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

  void _pickRole(UserRole role) {
    setState(() {
      _selected = role;
      _emailCtrl.text = _demoEmail(role);
    });
    _passFocus.requestFocus();
  }

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      showToast(context, 'Vui lòng nhập email và mật khẩu',
          type: NoticeType.warn);
      return;
    }
    setState(() => _submitting = true);
    final ok = await AppScope.read(context).login(email, password);
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Chọn nhanh vai trò mẫu (tùy chọn)',
                            style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ts)),
                      ),
                      const SizedBox(height: 10),
                      LayoutBuilder(builder: (context, c) {
                        final w = (c.maxWidth - 8) / 2;
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final role in UserRole.values)
                              SizedBox(
                                width: role == UserRole.thanhVien
                                    ? c.maxWidth
                                    : w,
                                child: _RoleButton(
                                  role,
                                  selected: _selected == role,
                                  onTap: () => _pickRole(role),
                                ),
                              ),
                          ],
                        );
                      }),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline, size: 18),
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
                      Text(
                        _selected == null
                            ? 'Nhập email/mật khẩu tài khoản của bạn'
                            : 'Tài khoản mẫu: ${_selected!.label}',
                        style: const TextStyle(
                            fontSize: 11.5, color: AppColors.tm),
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

class _RoleButton extends StatelessWidget {
  final UserRole role;
  final bool selected;
  final VoidCallback onTap;

  const _RoleButton(this.role, {required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentBg : AppColors.s1,
          border: Border.all(
              color: selected ? AppColors.accent : AppColors.bd, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(role.icon,
                size: 20, color: selected ? AppColors.accent : AppColors.ts),
            const SizedBox(height: 5),
            Text(role.shortLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color:
                        selected ? AppColors.accentText : AppColors.ts)),
            const SizedBox(height: 2),
            Text(role.hint,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: AppColors.tm)),
          ],
        ),
      ),
    );
  }
}
