
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddressModel {
  final String firstName;
  final String lastName;
  final String streetAddress;
  final String apartment;
  final String email;
  final String phone;
  final String city;
  final String zipCode;

  ShippingAddressModel({
    required this.firstName,
    required this.lastName,
    required this.streetAddress,
    required this.apartment,
    required this.email,
    required this.phone,
    required this.city,
    required this.zipCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "FirstName": firstName,
      "LastName": lastName,
      "StreetAddress": streetAddress,
      "Apartment": apartment,
      "Email": email,
      "Phone": phone,
      "City": city,
      "ZipCode": zipCode,
    };
  }
}

class ShippingAddressCubit extends Cubit<void> {
  ShippingAddressCubit() : super(null);

  Future<void> addShippingAddress(ShippingAddressModel address) async {
    final url = 'https://innova-hub.premiumasp.net/api/shipping-address/add';

    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        throw Exception("No token found");
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(address.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Shipping address added successfully');
        // You can emit success state here
      } else {
        print('Failed to add shipping address: ${response.body}');
        // Emit error state with message from response
      }
    } catch (e) {
      print('Error adding shipping address: $e');
      // Emit error state
    }
  }
}