import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/login_screen.dart';
import 'screens/shell_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LichHopApp());
}

class LichHopApp extends StatefulWidget {
  const LichHopApp({super.key});

  @override
  State<LichHopApp> createState() => _LichHopAppState();
}

class _LichHopAppState extends State<LichHopApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'Hệ thống Quản lý Lịch họp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        locale: const Locale('vi'),
        supportedLocales: const [Locale('vi'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const _Root(),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: state.isLoading && !state.isLoggedIn
          ? const Scaffold(
              key: ValueKey('splash'),
              body: Center(child: CircularProgressIndicator()),
            )
          : state.isLoggedIn
              ? const ShellScreen(key: ValueKey('shell'))
              : const LoginScreen(key: ValueKey('login')),
    );
  }
}
