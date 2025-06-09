
import 'dart:convert';
import 'package:http/http.dart' as http;


class PasswordService {

    Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    final url = Uri.parse("https://innova-hub.premiumasp.net/api/Profile/change-password");

    final body = jsonEncode({
      "currentPassword": oldPassword,
      "newPassword": newPassword,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("Status code: ${response.statusCode}");
      print("Response body: '${response.body}'");

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isEmpty) {
          return null; 
        } else {
          final responseData = jsonDecode(response.body);
          return responseData["message"] ?? "Password updated successfully";
        }
      } else {
        if (response.body.isEmpty) {
          return "Something went wrong. Empty response from server.";
        } else {
          final responseData = jsonDecode(response.body);
          return responseData["message"] ?? "Something went wrong";
        }
      }
    } catch (e) {
      print("Error occurred: $e");
      return "Error connecting to server";
    }
  }
}
