
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> addToCart(int productId, int quantity) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");
  if (token == null) {
    return false;
  }

  String url = 'https://innova-hub.premiumasp.net/api/Cart/add';

  Map<String, dynamic> body = {"ProductId": productId, "Quantity": quantity};

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

class CartService {
  final String baseUrl = 'https://innova-hub.premiumasp.net/api/Cart';

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    String? token = await _getToken();
    if (token == null) return [];

    try {
      var response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data["cartItems"] ?? []);
      }
    } catch (error) {
      print("Error fetching cart items: $error");
    }
    return [];
  }

  Future<void> clearCart() async {
    String? token = await _getToken();
    if (token == null) return;

    try {
      await http.delete(
        Uri.parse('$baseUrl/clear'),
        headers: {"Authorization": "Bearer $token"},
      );
    } catch (error) {
      print("Error clearing cart: $error");
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    String? token = await _getToken();
    if (token == null) return;

    try {
      await http.put(
        Uri.parse('$baseUrl/UpdateQuantity'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "productId": productId,
          "quantity": quantity,
        }),
      );
    } catch (error) {
      print("Error updating quantity: $error");
    }
  }

  Future<void> removeFromCart(int productId) async {
    String? token = await _getToken();
    if (token == null) return;

    try {
      await http.delete(
        Uri.parse('$baseUrl/remove/$productId'),
        headers: {"Authorization": "Bearer $token"},
      );
    } catch (error) {
      print("Error deleting item: $error");
    }
  }

  Future<bool> addToCart(int productId, int quantity) async {
    String? token = await _getToken();
    if (token == null) return false;

    try {
      var response = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "ProductId": productId,
          "Quantity": quantity,
        }),
      );

      return response.statusCode == 200;
    } catch (error) {
      print("Error adding to cart: $error");
      return false;
    }
  }
}