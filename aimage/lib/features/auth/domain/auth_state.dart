import 'dart:core';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState {
  User? user;

  AuthState({
    this.user,
  });

  bool get islogged => user != null;
}
