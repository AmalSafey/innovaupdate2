import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class AcceptService {
  static Future<Map<String, dynamic>> acceptOffer({required int dealId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      return {
        'success': false,
        'message': 'Authentication token not found. Please login again.',
      };
    }

    final Uri url =
        Uri.parse("https://innova-hub.premiumasp.net/api/Deals/accept-offer");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'DealId': dealId}),
      );

      print('Response body: ${response.body}'); // Debugging

      final decoded = jsonDecode(response.body);

      // Flexible message key handling
      String message = decoded['Message'] ??
          decoded['message'] ??
          'Unexpected response. Please try again.';

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': message};
      } else {
        return {'success': false, 'message': message};
      }
    } catch (e) {
      print("Error: $e");
      return {
        'success': false,
        'message': 'An error occurred. Please try again later.',
      };
    }
  }
}
