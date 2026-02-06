import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = "current_user";
  static const String _usersKey = "registered_users";

  // Register a new user
  static Future<bool> signUp(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing users
      final usersList = prefs.getStringList(_usersKey) ?? [];
      final users = usersList.map((user) => User.fromJson(jsonDecode(user))).toList();
      
      // Check if email already exists
      if (users.any((user) => user.email == email)) {
        return false; // Email already registered
      }
      
      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      
      // Save user (in a real app, you'd hash the password)
      users.add(newUser);
      final encodedUsers = users.map((user) => jsonEncode(user.toJson())).toList();
      await prefs.setStringList(_usersKey, encodedUsers);
      
      // Save current user session
      await prefs.setString(_userKey, jsonEncode(newUser.toJson()));
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Sign in user
  static Future<bool> signIn(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing users
      final usersList = prefs.getStringList(_usersKey) ?? [];
      final users = usersList.map((user) => User.fromJson(jsonDecode(user))).toList();
      
      // Find user by email (in a real app, you'd verify password hash)
      final user = users.firstWhere(
        (user) => user.email == email,
        orElse: () => throw Exception('User not found'),
      );
      
      // Save current user session
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get current logged-in user
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);
      
      if (userString != null) {
        return User.fromJson(jsonDecode(userString));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Sign out user
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}
