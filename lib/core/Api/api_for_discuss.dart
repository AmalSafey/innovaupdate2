// lib/services/discuss_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DiscussService {
  static Future<bool> sendDiscussMessage({
    required int dealId,
    required String message,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception("Authentication token not found");
    }

    final response = await http.post(
      Uri.parse("https://innova-hub.premiumasp.net/api/Deals/discuss-offer"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "DealId": dealId,
        "Message": message,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("Error: ${response.body}");
      return false;
    }
  }
}
