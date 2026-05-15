import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _client = Supabase.instance.client;

  // Register new user with email & password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Sign in existing user
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign out current user
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Get currently logged-in user
  static User? get currentUser => _client.auth.currentUser;

  // Check if a user is logged in
  static bool get isLoggedIn => _client.auth.currentUser != null;

  // Auth state change stream
  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  // Send password reset email
  static Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  // Resend email confirmation
  static Future<void> resendConfirmation(String email) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email,
    );
  }
}
