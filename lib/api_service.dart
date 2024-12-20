import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://9db3-2001-448a-2011-250e-80f5-bdce-ec3e-6df2.ngrok-free.app/api';
  static const String baseUrlImg =
      'https://9db3-2001-448a-2011-250e-80f5-bdce-ec3e-6df2.ngrok-free.app/storage';

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> changePassword(
      String token,
      String oldPassword,
      String newPassword,
      String newPasswordConfirmation) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/change-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 422) {
        final errors = jsonDecode(response.body);
        throw Exception('Validation Error: ${errors['message']}');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthenticated: Token tidak valid atau kedaluwarsa.');
      } else {
        throw Exception('Failed to change password: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
