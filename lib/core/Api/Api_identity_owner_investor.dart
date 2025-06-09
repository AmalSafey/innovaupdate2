
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class IdCardUploader {
  final File frontImage;
  final File backImage;

  IdCardUploader({required this.frontImage, required this.backImage});

  Future<void> upload(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No token found. Please login again.")),
        );
        return;
      }

      final uri = Uri.parse('https://innova-hub.premiumasp.net/api/Profile/upload-id-card');
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath('frontImage', frontImage.path));
      request.files.add(await http.MultipartFile.fromPath('backImage', backImage.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        debugPrint('Success: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Images uploaded successfully!")),
        );
      } else {
        final responseBody = await response.stream.bytesToString();
        debugPrint('Error ${response.statusCode}: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      debugPrint('Upload Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong.")),
      );
    }
  }
}
