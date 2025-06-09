
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/Models/products/product_comment_response.dart';

class ProductCommentsService {
  static const String baseUrl = 'https://innova-hub.premiumasp.net/api/Product';

  static Future<NewProductCommentsResponse?> getAllProductComments(
      int productId) async {
    try {
      final url = Uri.parse('$baseUrl/GetAllProductComments/$productId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NewProductCommentsResponse.fromJson(jsonData);
      } else {
        print('Failed to load comments. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching product comments: $e');
      return null;
    }
  }
}