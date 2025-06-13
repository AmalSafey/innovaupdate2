// deal_acceptance_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DealAcceptanceService {
  static const String baseUrl = 'https://innova-hub.premiumasp.net/api';

  // Get stored token from SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Accept deal offer
  Future<bool> acceptDealOffer({
    required int dealId,
    required int notificationId,
    String? message,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/Deal/accept'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'dealId': dealId,
          'notificationId': notificationId,
          'message': message ?? 'Deal offer accepted',
          'acceptedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to accept deal: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error accepting deal: $e');
      return false;
    }
  }

  // Get deal details
  Future<Map<String, dynamic>?> getDealDetails(int dealId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/Deal/$dealId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to get deal details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting deal details: $e');
      return null;
    }
  }

  // Send response to admin
  Future<bool> sendToAdmin({
    required int dealId,
    required String message,
    required String status,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/Deal/submit-for-review'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'dealId': dealId,
          'message': message,
          'status': status,
          'submittedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to send to admin: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending to admin: $e');
      return false;
    }
  }
}
