//riverpod provider flutter

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Inpainting generated list controller
final authNotifierProvider = StateNotifierProvider<AuthNotifier, Session?>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<Session?> {
  AuthNotifier() : super(null);

  void updateValue(Session? value) {
    state = value;
  }

  void reset() {
    state = null;
  }
}
