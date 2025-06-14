import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class DealAcceptanceServicefordisscuss {
  static const String acceptDealEndpoint =
      'https://innova-hub.premiumasp.net/api/Deals/respond-to-offer'; // Replace with your actual endpoint

  Future<bool> acceptDeal({
    required int dealId,
    required String investorId,
    required String message,
  }) async {
    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse(acceptDealEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add token to headers
        },
        body: jsonEncode({
          "DealId": dealId,
          "InvestorId": investorId,
          "IsAccepted": false,
          "Message": message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error accepting deal: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception in acceptDeal: $e');
      return false;
    }
  }
}
