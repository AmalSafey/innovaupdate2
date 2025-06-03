
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  final String baseUrl = 'https://innova-hub.premiumasp.net/api/Wishlist';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<bool> addProductToWishlist(int productId) async {
    String? token = await _getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addProductToWishlist/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error adding product to wishlist: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchWishlist() async {
    String? token = await _getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wishlist'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data["Wishlist"] ?? []);
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
    }

    return [];
  }

  Future<bool> removeProductFromWishlist(int productId) async {
    String? token = await _getToken();
    if (token == null) return false;

    try {
      final url = '$baseUrl/remove/$productId'; 
      print('DELETE URL: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Delete response: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting product from wishlist: $e');
      return false;
    }
  }
}

