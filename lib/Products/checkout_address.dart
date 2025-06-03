import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/Data_textfield.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutAddress extends StatefulWidget {
  const CheckoutAddress({
    Key? key,
    this.isEditing = false, // default value is false
    this.firstName,
    this.lastName,
    this.streetAddress,
    this.apartment,
    this.email,
    this.phone,
    this.city,
    this.zipCode,
  }) : super(key: key);

  static const String routeName = 'address';

  final bool isEditing;
  final String? firstName;
  final String? lastName;
  final String? streetAddress;
  final String? apartment;
  final String? email;
  final String? phone;
  final String? city;
  final String? zipCode;

  @override
  State<CheckoutAddress> createState() => _CheckoutAddressState();
}

class _CheckoutAddressState extends State<CheckoutAddress> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final streetAddressController = TextEditingController();
  final apartmentController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      firstNameController.text = widget.firstName ?? '';
      lastNameController.text = widget.lastName ?? '';
      streetAddressController.text = widget.streetAddress ?? '';
      apartmentController.text = widget.apartment ?? '';
      emailController.text = widget.email ?? '';
      phoneController.text = widget.phone ?? '';
      cityController.text = widget.city ?? '';
      zipCodeController.text = widget.zipCode ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.white3Color,
      appBar: AppBar(
        backgroundColor: Constant.whiteColor,
        elevation: 0,
        title: const Text(
          'Innova',
          style: TextStyle(
              color: Constant.blackColorDark,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/image-13.png'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DataTextField(
                      hint: 'First Name', controller: firstNameController),
                  const SizedBox(height: 13),
                  DataTextField(
                      hint: 'Last Name', controller: lastNameController),
                  const SizedBox(height: 13),
                  DataTextField(
                      hint: 'Street Address',
                      controller: streetAddressController),
                  const SizedBox(height: 13),
                  DataTextField(
                      hint: 'Apartment, Suite, etc..',
                      controller: apartmentController),
                  const SizedBox(height: 13),
                  DataTextField(hint: 'Email', controller: emailController),
                  const SizedBox(height: 13),
                  DataTextField(hint: 'Phone', controller: phoneController),
                  const SizedBox(height: 13),
                  DataTextField(hint: 'City', controller: cityController),
                  const SizedBox(height: 13),
                  DataTextField(
                      hint: 'Zip code', controller: zipCodeController),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildOutlinedButton(
                          'Back', () => Navigator.pop(context)),
                      _buildElevatedButton(
                          widget.isEditing ? 'Update' : 'Save', _saveAddress),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Constant.mainColor),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        streetAddressController.text.isEmpty ||
        cityController.text.isEmpty ||
        phoneController.text.isEmpty) {
      _showDialog("Validation Error", "Please fill in all required fields.");
      return;
    }

    final model = {
      "FirstName": firstNameController.text,
      "LastName": lastNameController.text,
      "StreetAddress": streetAddressController.text,
      "Apartment": apartmentController.text,
      "Email": emailController.text,
      "Phone": phoneController.text,
      "City": cityController.text,
      "ZipCode": zipCodeController.text,
    };

    try {
      setState(() => isLoading = true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        setState(() => isLoading = false);
        _showDialog("Error", "Authentication token not found.");
        return;
      }

      final url = widget.isEditing
          ? 'https://innova-hub.premiumasp.net/api/shippingaddress/update'
          : 'https://innova-hub.premiumasp.net/api/shippingaddress/add';

      final response = widget.isEditing
          ? await http.patch(
              Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(model),
            )
          : await http.post(
              Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(model),
            );

      setState(() => isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await prefs.setString("StreetAddress", streetAddressController.text);
        await prefs.setString("City", cityController.text);

        Navigator.pop(context, true); // notify previous screen
      } else {
        final body = jsonDecode(response.body);
        _showDialog("Error", body['message'] ?? 'Failed to save address.');
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showDialog("Error", "Something went wrong: $e");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:
                const Text("OK", style: TextStyle(color: Constant.mainColor)),
          ),
        ],
      ),
    );
  }

  static Widget _buildOutlinedButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Constant.whiteColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        side: const BorderSide(color: Constant.greyColor2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        minimumSize: const Size(170, 50),
      ),
      child: Text(text,
          style: const TextStyle(color: Constant.mainColor, fontSize: 15)),
    );
  }

  static Widget _buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        backgroundColor: Constant.mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        minimumSize: const Size(170, 50),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 18, color: Constant.whiteColor)),
    );
  }
}
