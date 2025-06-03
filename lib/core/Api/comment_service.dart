
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentService {

  //"https://innova-hub.premiumasp.net/api/Product/AddComment"
  static const String baseUrl = 'innova-hub.premiumasp.net';   // name of the server:
  
  static Future<String> postComment(int productId, String comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return "Error: No token found! Please log in.";
    }

    Map<String, dynamic> requestBody = {
      "ProductId": productId,
      "Comment": comment
    };

    var url = Uri.https(baseUrl, '/api/Product/AddComment');
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return "Comment added successfully!";
    } else {
      return "Failed to add comment!";
    }
  }
}