import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:innovahub_app/Auth/Auth_Cubit/Auth_cubit.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_states.dart';
import 'package:innovahub_app/Auth/login/login_screen.dart';
import 'package:innovahub_app/Custom_Widgets/Text_Field_Widget.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/home_Tap_Investor.dart';
import 'package:innovahub_app/home/home_Tap_owner.dart';
import 'package:innovahub_app/home/user_home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  const RegisterScreen({super.key}); // routeName of this screen:

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final districtController = TextEditingController();
  final phoneNumberController = TextEditingController();

  bool isObscurepassword = true;
  bool isObscureconfirm = true;
  String? selectedRoleId;
  bool isLoading = false;
  String? errorMessage;

  final _formKey = GlobalKey<FormState>(); // key of form:

  // Roles for Dropdown:
  final List<Map<String, String>> roles = [
    {"id": "b75a438c-e393-44ae-aeff-003cb41f9c74", "name": "Investor"},
    {"id": "e492b23e-3447-4a0b-91ed-f969a27e6c86", "name": "BusinessOwner"},
    {"id": "485d65fb-1977-4e45-a4f7-381f303ee6ac", "name": "Admin"},
    {"id": "500656a0-da3a-46e7-8038-c393108fb513", "name": "Customer"}
  ];

  // Method to show a dialog
  void _showDialog(BuildContext context, String message,
      {VoidCallback? onClose}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: const TextStyle(
            color: Constant.mainColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق الـ Dialog
              if (onClose != null) {
                onClose(); // تنفيذ الإجراء بعد إغلاق التنبيه
              }
            },
            child: const Text(
              "OK",
              style: TextStyle(
                color: Constant.mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(listener: (context, state) {
      print("Current state: $state");

      if (state is RegisterSuccessState) {
        // Role-based navigation:
        if (selectedRoleId == "e492b23e-3447-4a0b-91ed-f969a27e6c86") {
          // BusinessOwner
          Navigator.pushNamed(context, HomeScreenOwner.routeName);
        } else if (selectedRoleId == "b75a438c-e393-44ae-aeff-003cb41f9c74") {
          // Investor
          Navigator.pushNamed(context, HomeScreenInvestor.routeName);
        } else if (selectedRoleId == "500656a0-da3a-46e7-8038-c393108fb513") {
          // Customer
          Navigator.pushNamed(context, UserHomeScreen.routeName);
        } /*else {
            // Default or error handling (optional)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid role selected')),
            );
          }*/
        _showDialog(context, state.messagesuccess, onClose: () {
          /*Future.microtask(() {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            });*/
        });
      } else if (state is RegisterErrorStata) {
        print("Registration failed, staying on the same page.");

        _showDialog(context, state.message);
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Sign Up',
                style: TextStyle(
                    color: Constant.blackColorDark,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      "Welcome To Innova App",
                      style: TextStyle(
                          color: Constant.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      "Start Your journey now!",
                      style: TextStyle(
                        color: Constant.greyColor,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Row for First Name and Last Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFieldWidget(
                          controller: firstnameController,
                          label: 'First Name',
                          hint: 'Enter Your First Name',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFieldWidget(
                          controller: lastnameController,
                          label: 'Last Name',
                          hint: 'Enter Your Last Name',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  TextFieldWidget(
                    controller: emailController,
                    label: 'Email',
                    hint: 'Enter Your Email',
                    isEmail: true,
                  ),

                  const SizedBox(height: 15),

                  TextFieldWidget(
                    controller: passwordController,
                    label: 'Password',
                    hint: 'Enter Your Password',
                    isPassword: true,
                    obscureText: isObscurepassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscurepassword =
                              !isObscurepassword; // تبديل حالة النص عند الضغط
                        });
                      },
                      icon: Icon(
                        isObscurepassword
                            ? Icons.visibility_off
                            : Icons.visibility, // To show Icon:
                        color: isObscurepassword
                            ? Colors.grey
                            : Constant.blackColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /* TextFieldWidget(
                  controller: confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm Your Password',
                  isPassword: true,
                ),*/

                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      // onChanged:isChanged,
                      controller: confirmPasswordController,
                      obscureText: isObscureconfirm,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(
                            14), // تقليل المسافة داخل الـ TextField
                        labelText: 'Confirm password',
                        labelStyle: const TextStyle(
                            color: Color(0xFF333333), fontSize: 15),
                        hintText: 'please confirm your password',
                        hintStyle: const TextStyle(
                          color: Color(0xFF333333),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFFB2B1B1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              const BorderSide(color: Constant.greyColor2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Constant.greyColor2),
                        ),

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscureconfirm =
                                  !isObscureconfirm; // تبديل حالة النص عند الضغط
                            });
                          },
                          icon: Icon(
                            isObscureconfirm
                                ? Icons.visibility_off
                                : Icons.visibility, // To show Icon:
                            color: isObscurepassword
                                ? Colors.grey
                                : Constant.blackColor,
                          ),
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Row for Password and Confirm Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFieldWidget(
                          controller: countryController,
                          label: 'Country',
                          hint: 'Enter Your Country',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFieldWidget(
                          controller: cityController,
                          label: 'City',
                          hint: 'Enter Your City',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFieldWidget(
                          controller: districtController,
                          label: 'District',
                          hint: 'Enter Your District',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextFieldWidget(
                          controller: phoneNumberController,
                          label: 'Phone Number',
                          hint: 'Enter Your Phone Number',
                          isPhone: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Dropdown for Role selection
                  //padding: const EdgeInsets.only(left: 10, right: 10),

                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: DropdownButtonFormField<String>(
                      value: selectedRoleId,
                      decoration: InputDecoration(
                        labelText: "Select Role",
                        labelStyle: const TextStyle(
                          color: Constant.greyColor3,
                          fontSize: 15,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide:
                              const BorderSide(color: Constant.greyColor2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Constant.greyColor2,
                            //width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Constant.greyColor2,
                            //width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                      items: roles.map((role) {
                        return DropdownMenuItem<String>(
                          value: role['id'],
                          child: Text(role['name']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRoleId = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a role' : null,
                    ),
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        //validateForm();
                        if (_formKey.currentState!.validate()) {
                          // Call the register method from the AuthCubit
                          await context.read<AuthCubit>().register(
                                firstName: firstnameController.text,
                                lastName: lastnameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                confirmPassword: confirmPasswordController.text,
                                city: cityController.text,
                                country: countryController.text,
                                district: districtController.text,
                                phoneNumber: phoneNumberController.text,
                                roleId: selectedRoleId!,
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.mainColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 13.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                      child: Text(
                        state is RegisterLoadingState
                            ? 'Loading...'
                            : 'Create Account',
                        style: const TextStyle(
                            color: Constant.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Constant.blackColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routname);
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Constant.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  /*void validateForm() {
    if (_formKey.currentState!.validate()) {
      // register:
      // Call the register method from the AuthCubit
      context.read<AuthCubit>().register(
            firstName: firstnameController.text,
            lastName: lastnameController.text,
            email: emailController.text,
            password: passwordController.text,
            confirmPassword: confirmPasswordController.text,
            city: cityController.text,
            country: countryController.text,
            district: districtController.text,
            phoneNumber: phoneNumberController.text,
            roleId: selectedRoleId!,
          );
    }
  }*/
}
