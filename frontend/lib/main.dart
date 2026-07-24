import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/role_select_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CbseApp());
}

class CbseApp extends StatelessWidget {
  const CbseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService()..loadFromDisk(),
      child: MaterialApp(
        title: 'CBSE Class 5 Paper Bank',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        home: const _StartupGate(),
      ),
    );
  }
}

/// Skips straight to Home if a token is already saved on disk, otherwise
/// shows the role-select flow. (Note: this only checks for a saved token,
/// not whether it's still valid server-side -- the first API call will
/// surface an auth error if it has expired, at which point you should
/// route the user back to RoleSelectScreen.)
class _StartupGate extends StatelessWidget {
  const _StartupGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (auth.token != null && auth.currentUser != null) {
      return const HomeScreen();
    }
    return const RoleSelectScreen();
  }
}
