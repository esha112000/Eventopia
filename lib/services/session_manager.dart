import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionManager {
  final _secureStorage = const FlutterSecureStorage();

  /// Save token to secure storage
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: 'authToken', value: token);
    } catch (e) {
      print('Error saving token: $e');
    }
  }

  /// Retrieve token from secure storage
  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: 'authToken');
    } catch (e) {
      print('Error reading token: $e');
      return null;
    }
  }

  /// Clear token from secure storage
  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: 'authToken');
    } catch (e) {
      print('Error clearing token: $e');
    }
  }

  /// Validate token and refresh if necessary
  Future<bool> validateToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Get and refresh the token
        final idToken = await user.getIdToken(true); // Force refresh
        if (idToken != null) {
          await saveToken(idToken); // Save the refreshed token
          return true;
        }
      } catch (e) {
        print('Error validating token: $e');
        return false; // Token is invalid or failed to refresh
      }
    }
    print('No user is currently logged in.');
    return false; // No user logged in
  }

  /// Check if a token exists in secure storage
  Future<bool> hasValidToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
