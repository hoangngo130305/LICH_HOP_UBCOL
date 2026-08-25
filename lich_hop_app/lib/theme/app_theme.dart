import 'package:flutter/material.dart';

/// Bảng màu lấy nguyên từ prototype HTML v2.
class AppColors {
  static const navy = Color(0xFF1A2744);
  static const navy2 = Color(0xFF253660);
  static const green = Color(0xFF1E4A3A);
  static const green2 = Color(0xFF2A6350);

  static const accent = Color(0xFF3B7DD8);
  static const accentBg = Color(0xFFE6F1FB);
  static const accentText = Color(0xFF185FA5);

  static const okGreen = Color(0xFF1D9E75);
  static const greenBg = Color(0xFFE1F5EE);
  static const greenText = Color(0xFF0F6E56);

  static const warn = Color(0xFFBA7517);
  static const warnBg = Color(0xFFFAEEDA);
  static const warnText = Color(0xFF854F0B);

  static const danger = Color(0xFFD85A30);
  static const dangerBg = Color(0xFFFAECE7);
  static const dangerText = Color(0xFF993C1D);

  static const purple = Color(0xFF534AB7);
  static const purpleBg = Color(0xFFEDE9FE);

  static const s0 = Color(0xFFF4F4F2);
  static const s1 = Color(0xFFF9F9F8);
  static const s2 = Color(0xFFFFFFFF);

  static const bd = Color(0xFFE2E2DE);
  static const bds = Color(0xFFCCCCC8);

  static const tp = Color(0xFF1A1A18);
  static const ts = Color(0xFF5F5E5A);
  static const tm = Color(0xFF9A9994);
}

class AppTheme {
  static const radius = 8.0;
  static const cardRadius = 12.0;

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.navy,
        primary: AppColors.navy,
        surface: AppColors.s2,
      ),
      scaffoldBackgroundColor: AppColors.s0,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.tp,
        displayColor: AppColors.tp,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.bd,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.tm),
        border: _border(AppColors.bds),
        enabledBorder: _border(AppColors.bds),
        focusedBorder: _border(AppColors.accent, width: 1.4),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        contentTextStyle: TextStyle(color: Colors.white, fontSize: 13),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  static OutlineInputBorder _border(Color c, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: c, width: width),
      );

  // Kiểu chữ dùng lại nhiều nơi
  static const h1 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const h2 = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
  static const sub = TextStyle(fontSize: 12.5, color: AppColors.ts);
  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.ts,
    letterSpacing: .6,
  );
  static const meta = TextStyle(fontSize: 11.5, color: AppColors.ts);
  static const itemTitle = TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500);
}
