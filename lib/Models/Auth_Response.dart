

import 'dart:convert';
import 'package:http/http.dart' as http;

 // Model:
class AuthService {

  static const String baseUrl = 'https://192.168.1.4:7151/api/Account';
  static const String registerApi = '$baseUrl/register';
  static const String loginApi = '$baseUrl/login';

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String city,
    required String country,
    required String district,
    required String phoneNumber,
    required String roleId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(registerApi),
        headers: {
          'Content-Type': 'application/json', // Specify that the body is JSON
        },
        body: jsonEncode({
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "city": city,
          "phoneNumber": phoneNumber,
          "district": district,
          "country": country,
          "roleId": roleId,
        }),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body); // Successful registration
      } else {
        // Handle error response
        Map<String, dynamic> errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['Message'] ??
            'Failed to register. Please try again.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
