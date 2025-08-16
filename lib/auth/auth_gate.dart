import 'package:flutter/material.dart';
import 'auth_state.dart';
import '../dashboard/main_shell.dart';
import 'login.dart';

/// Decides whether to show Login or Home
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: authState,
      builder: (context, loggedIn, _) {
        if (loggedIn) return const MainShell();
        return const LoginScreen();
      },
    );
  }
}
