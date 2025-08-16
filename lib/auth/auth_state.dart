import 'package:flutter/material.dart';

/// Simple in-memory auth flag
class AuthState extends ValueNotifier<bool> {
  AuthState() : super(false);
}

final authState = AuthState();
