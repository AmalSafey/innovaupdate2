
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/core/services/cache_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiManagerProfiles {

  //https://innova-hub.premiumasp.net/api/Profile/profile
 //https://innova-hub.premiumasp.net/api/Profile/profile-picture      // url to upload image:


  static const String baseUrl = 'https://innova-hub.premiumasp.net';      // name of the server:
  static const String apiUrl = "https://innova-hub.premiumasp.net/api/Profile/profile-picture";

   // to get profile info:

   static Future<UserProfile> fetchUserProfile() async {
    try {
   
      String? token = CacheService.getString(key:"token");    

      if (token == null) throw Exception("Token is missing, please log in again.");

      final response = await http.get(
        Uri.parse("$baseUrl/api/Profile/profile"),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserProfile.fromJson(data);

      } else {
        throw Exception("Failed to load profile data");
      }
      
    } catch (error) {
      throw Exception("Error fetching user profile: $error");
      
    }
  }

   // Function To Upload profile Image:
    static Future<String?> uploadProfileImage(File imageFile, BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
       // ignore: use_build_context_synchronously
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" the token is missing or invalid.")),
      );
      return null;
    }

    try {

      var request = http.MultipartRequest('POST', 
      Uri.parse("$baseUrl/api/Profile/profile-picture"));

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseData);
        String newProfileImageUrl = jsonResponse["ProfileImageUrl"];
        String fullUrl = "https://innova-hub.premiumasp.net/$newProfileImageUrl";

        // to save the new image in the shared preferences:
        await prefs.setString("profileImageUrl", fullUrl);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("uploded Image successfully.")),
        );

        return fullUrl;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" Failed to upload image ${response.statusCode}")),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")),
      );
      return null;
    }
   }


  // Function to delete Image:
   static Future<bool> deleteImage(BuildContext context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("the token is missing or invalid.")),
      );
      return false;
    }

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove("profileImageUrl");     // to remove image from shared preferences:

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("profile image deleted successfully.")),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete profile image: ${response.statusCode}")),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting profile image: $e")),
      );
      return false;
    }
  }

  

}

