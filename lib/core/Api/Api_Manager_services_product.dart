
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final SharedPreferences prefs;
  ProductService(this.prefs);

  Future<void> addProduct({
    required String productName,
    required String description,
    required String price,
    required String discount,
    required String categoryId,
    required String stock,
    required String dimensions,
    required String weight,
    required String sizeNames,
    required String colorNames,
    required File homePicture,
    File? image2,
    File? image3,
    required BuildContext context,
  }) async {
    if (!homePicture.existsSync()) {
      _showError(context, "Please select a home picture.");
      return;
    }

    try {
      String? token = prefs.getString("token");
      if (token == null) throw Exception("User is not authenticated!");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://innova-hub.premiumasp.net/api/Product"),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      request.fields.addAll({
        'ProductName': productName,
        'Description': description,
        'Price': price,
        'Discount': discount,
        'CategoryId': categoryId,
        'Stock': stock,
        'Dimensions': dimensions,
        'Weight': weight,
        'SizeNames': sizeNames,
        'ColorNames': colorNames,
      });

      request.files.add(await http.MultipartFile.fromPath('HomePicture', homePicture.path));
      if (image2 != null) {
        request.files.add(await http.MultipartFile.fromPath('Pictures', image2.path));
      }
      if (image3 != null) {
        request.files.add(await http.MultipartFile.fromPath('Pictures', image3.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccess(context, "Product added successfully!");
      } else {
        var errorMessage = decodedResponse['errors']?['Pictures']?.first ??
            decodedResponse['Message'] ?? "Unknown error occurred";
        _showError(context, errorMessage);
      }
    } catch (e) {
      _showError(context, "Exception: $e");
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
