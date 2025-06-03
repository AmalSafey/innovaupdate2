
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:innovahub_app/Auth/login/reset_password.dart';
import 'package:http/http.dart' as http;



class ForgetPasswordScreen extends StatelessWidget {
  static const String routname = "forget";
  final email = TextEditingController();

  ForgetPasswordScreen({super.key});

  Future<void> sendForgetPasswordRequest(BuildContext context, String email) async {
    final url = Uri.parse('https://innova-hub.premiumasp.net/api/Profile/generate-token');

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      Navigator.pop(context);
      final responseData = jsonDecode(response.body);
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 && responseData.containsKey('Message')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['Message']),
        ));

        Navigator.pushNamed(
          context,
          resetpassword.routname,
          arguments: {'email': email},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unexpected response from the server.'),
        ));
      }
    } catch (error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final userEmail = email.text.trim();
                if (userEmail.isNotEmpty) {
                  sendForgetPasswordRequest(context, userEmail);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter your email.'),
                  ));
                }
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
