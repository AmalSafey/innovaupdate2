import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:innovahub_app/Auth/login/login_screen.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Custom_Widgets/Text_Field_Widget.dart';

// ignore: camel_case_types
class resetpassword extends StatefulWidget {
  static const String routname = "reset_password";

  const resetpassword({super.key});

  @override
  State<resetpassword> createState() => _resetpasswordState();
}

// ignore: camel_case_types
class _resetpasswordState extends State<resetpassword> {
  final password = TextEditingController();
  final email1 = TextEditingController(); 
  final token = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscurepassword = true;

 Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = password.text.trim();
    final email = email1.text.trim(); // أخذ البريد الإلكتروني من الحقل
    final tokenValue = Uri.decodeComponent(token.text.trim());

    print('Decoded Token: $tokenValue');  // طباعة التوكن بعد فك التشفير
    print('Email: $email'); // طباعة البريد الإلكتروني للتحقق

    final url = Uri.parse('https://innova-hub.premiumasp.net/api/Profile/reset-password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,  // إرسال البريد الإلكتروني الذي تم إدخاله في الحقل
          'token': tokenValue,
          'newPassword': newPassword,
        }),
      );

      final responseData = jsonDecode(response.body);
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("Password reset successful");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful')),
        );
        Navigator.pushReplacementNamed(context, LoginScreen.routname);
      } else {
        print("Failed response: ${response.body}");
        final message = responseData['Message'] ?? 'Reset failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Constant.blackColorDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/reset_password_photo.jpg',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Reset Password now",
                    style: TextStyle(
                      color: Constant.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // حقل البريد الإلكتروني
                TextFieldWidget(
                  controller: email1,
                  label: 'Email',
                  hint: 'Enter Your Email',
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  controller: token,
                  label: 'Token',
                  hint: 'Enter your token',
                  isPassword: false,
                ),
                const SizedBox(height: 10),
                TextFieldWidget(
                  controller: password,
                  label: 'Password',
                  hint: 'Enter Your Password',
                  isPassword: true,
                  obscureText: isObscurepassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscurepassword = !isObscurepassword;
                      });
                    },
                    icon: Icon(
                      isObscurepassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color:
                          isObscurepassword ? Colors.grey : Constant.blackColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.mainColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 13.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constant.whiteColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// ignore: camel_case_types

/*class resetpassword extends StatefulWidget {

  static const String routname = "reset_password";

  const resetpassword({super.key});                
  @override
  State<resetpassword> createState() => _resetpasswordState();              // routeName of this screen:

}

// ignore: camel_case_types
class _resetpasswordState extends State<resetpassword> {

  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final token = TextEditingController();
  bool isObscurepassword = true;
  bool isObscureconfirm = true;
  final _formKey = GlobalKey<FormState>(); // key of form:


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(
              color: Constant.blackColorDark,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const SizedBox( height: 30,),
                 Image.asset('assets/images/reset_password_photo.jpg',
                 width: double.infinity,
                fit: BoxFit.fill,
                 ),
            
                const SizedBox(height: 30,),
            
                const Padding(
                  padding:  EdgeInsets.only(left:10),
                  child:  Text(
                    "Reset Password now",
                    style: TextStyle(
                        color: Constant.blackColor,
                         fontSize: 24, 
                         fontWeight: FontWeight.bold),
                  ),
                ),
                
                const SizedBox(
                  height: 10,
                ),
          
          
               TextFieldWidget(controller: token, label: 'Token', hint:'Enter your token' ,
               isPassword:false,
               
               ),
          
          
          
          
                
               /* const Padding(
                  padding:  EdgeInsets.only(left: 10),
                  child:  Text(
                    "Enter your new password",
                    style: TextStyle(
                      color: Constant.greyColor, 
                      fontSize: 18),
                  ),
                ),*/
          
                const SizedBox(
                  height: 10,
                ),
                
                TextFieldWidget(
                  controller: password, label: 'Password', hint:'Enter Your Password',
                  isPassword: true,obscureText: isObscurepassword,
                     suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscurepassword = !isObscurepassword;        // تبديل حالة النص عند الضغط
                            });
                          },
          
                          icon: Icon(
                            isObscurepassword ? Icons.visibility_off
                                : Icons.visibility,          // To show Icon:
                            color: isObscurepassword
                                ? Colors.grey
                                : Constant.blackColor,
                          ),
                        ),
                  ),
                
                const SizedBox(height: 10,),
          
                 /*const Padding(
                  padding:  EdgeInsets.only(left: 10),
                  child:  Text(
                    "Confirm new password",
                    style: TextStyle(
                      color: Constant.greyColor, 
                      fontSize: 18),
                  ),
                ),*/
          
                const SizedBox(height: 10,),
          
                TextFieldWidget(
                controller:confirmPassword , label: 'Confirm password', hint:'Confirm Your Password',
                isPassword: true,obscureText: isObscurepassword,
                suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscurepassword = !isObscurepassword;        // تبديل حالة النص عند الضغط
                          });
                        },

                        icon: Icon(
                          isObscurepassword ? Icons.visibility_off
                              : Icons.visibility,          // To show Icon:
                          color: isObscurepassword
                              ? Colors.grey
                              : Constant.blackColor,
                        ),
                      ),
                ),
                
                   const SizedBox(height: 20,),


                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                    Navigator.pushReplacementNamed(context, LoginScreen.routname,
                    arguments: password.text,                // Navigate to LoginScreen:

                    );

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.mainColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 13.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constant.whiteColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
            
                
              ],
            ),
          ),
        ),
      ),
    );


  }




}*/