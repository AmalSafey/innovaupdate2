
import 'dart:convert';
import 'dart:io';
import 'package:innovahub_app/Models/Deals/Business_owner_response.dart';
import 'package:innovahub_app/Models/Deals/Deal_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiManagerDeals {
  static const String baseUrl =
      'https://innova-hub.premiumasp.net'; // name of the server:

  // Function To post deals:
  static Future<String> addDeal(DealModel deal, List<File?> images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      return "User not authenticated.";
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/api/Deals/add"),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll(
        deal.toJson().map((key, value) => MapEntry(key, value.toString())));

    for (File? image in images) {
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('Pictures', image.path));
      }
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(responseData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return "Success";
    } else {
      return jsonResponse["errors"]?.toString() ?? "Failed to add deal.";
    }
  }

  // https://innova-hub.premiumasp.net/api/Deals/GetAllDeals
  // Function to get all deals:
  static Future<List<BusinessOwnerResponse>> getAllDeals() async {
    //final String url = https://innova-hub.premiumasp.net/api/Deals/GetAllDeals;

    try {
      final response =
          await http.get(Uri.parse("$baseUrl/api/Deals/GetAllDeals"));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data
            .map((json) => BusinessOwnerResponse.fromjson(json))
            .toList();
      } else {
        throw Exception("Failed to load businesses");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
