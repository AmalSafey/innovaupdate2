import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/controller/user_home_layout_cubit/user_home_layout_cubit.dart';
import 'package:innovahub_app/home/model/user_home_layout.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  static const String routeName = 'home_screen'; // routeName of this screen:

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              backgroundImage:
                  AssetImage('assets/images/image-13.png'), // ضع الصورة هنا
            ),
          ),
        ],
      ),
      body: BlocBuilder<UserHomeLayoutCubit, UserHomeLayoutState>(
        builder: (context, state) {
          return PageView.builder(
            controller: UserHomeLayoutCubit.get(context).pageController,
            onPageChanged: (value) {
              UserHomeLayoutCubit.get(context).changePage(value);
            },
            itemBuilder: (context, index) {
              return UserHomeLayout.screens[index];
            },
          );
        },
      ),
      bottomNavigationBar:
          BlocBuilder<UserHomeLayoutCubit, UserHomeLayoutState>(
        builder: (context, state) {
          return BottomNavigationBar(
            backgroundColor: Constant.whiteColor,
            elevation: 0,
            items: UserHomeLayout.bottomNavBarItems,
            currentIndex: UserHomeLayoutCubit.get(context).currentIndex,
            onTap: (index) {
              UserHomeLayoutCubit.get(context).changePage(index);
            },
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black,
            selectedLabelStyle: const TextStyle(
              fontSize: 16,
            ),
          );
        },
      ),
    );
  }
}



/*

class RegisterDesign extends StatefulWidget {
  
  static const String routeName = 'register_screen';                 //routeName:

  @override
  State<RegisterDesign> createState() => _RegisterDesignState();
}

class _RegisterDesignState extends State<RegisterDesign> {
  // Controllers
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final districtController = TextEditingController();
  final phoneNumberController = TextEditingController();

  // State Variables
  bool isObscurePassword = true;
  bool isObscureConfirm = true;
  String? selectedRoleId;

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Roles for Dropdown
  final List<Map<String, String>> roles = [
    {"id": "11c8c40c-169a-40cd-b6c6-b56fa4183b5a", "name": "BusinessOwner"},
    {"id": "7a5101fd-78f9-4608-a881-bfbb501c822d", "name": "Admin"},
    {"id": "ac5cc1fb-ba2e-4721-9449-3623242cc160", "name": "Investor"},
    {"id": "d27aab0b-5c65-4efe-8b29-b8c476568e15", "name": "Customer"},
  ];

  // Method to show a dialog
  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: TextStyle(
            color: Color.fromARGB(255, 112, 182, 182),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              "OK",
              style: TextStyle(
                color: Color.fromARGB(255, 112, 182, 182),
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
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          _showDialog(context, "Registration successful!");
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        } else if (state is RegisterErrorStata) {
          _showDialog(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Sign Up'),
            backgroundColor: Color.fromARGB(255, 112, 182, 182),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Input Fields
                    _buildTextFormField(
                      controller: firstnameController,
                      label: 'First Name',
                      hint: 'Enter your first name',
                    ),
                    _buildTextFormField(
                      controller: lastnameController,
                      label: 'Last Name',
                      hint: 'Enter your last name',
                    ),
                    _buildTextFormField(
                      controller: emailController,label: 'Email',
                      hint: 'Enter your email',
                    ),
                    _buildPasswordFormField(
                      controller: passwordController,
                      label: 'Password',
                      obscureText: isObscurePassword,
                      onToggleVisibility: () {
                        setState(() {
                          isObscurePassword = !isObscurePassword;
                        });
                      },
                    ),
                    _buildPasswordFormField(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      obscureText: isObscureConfirm,
                      onToggleVisibility: () {
                        setState(() {
                          isObscureConfirm = !isObscureConfirm;
                        });
                      },
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      controller: phoneNumberController,
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                    ),
                    _buildTextFormField(
                      controller: countryController,
                      label: 'Country',
                      hint: 'Enter your country',
                    ),
                    _buildTextFormField(
                      controller: cityController,
                      label: 'City',
                      hint: 'Enter your city',
                    ),
                    _buildTextFormField(
                      controller: districtController,
                      label: 'District',
                      hint: 'Enter your district',
                    ),
                    // Dropdown for Roles
                    _buildDropdownField(),
                    SizedBox(height: 20),
                    // Submit Button
                    _buildSubmitButton(context, state),
                    SizedBox(height: 20),
                    // Navigation to Login
                    _buildLoginNavigation(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context, AuthStates state) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
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
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 112, 182, 182),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Text(
        state is RegisterLoadingState ? 'Loading...' : 'Create Account',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget _buildLoginNavigation(BuildContext context) {return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, LoginScreen.routname);
          },
          child: Text(
            "Log In",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 112, 182, 182),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 112, 182, 182),
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 239, 247, 247),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 112, 182, 182),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 112, 182, 182),
              width: 2.0,
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        ),
        validator: validator ??
            (value) => value!.isEmpty ? 'Please enter your $label' : null,
      ),
    );
  }

  Widget _buildPasswordFormField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 112, 182, 182),
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 239, 247, 247),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 112, 182, 182),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 112, 182, 182),
              width: 2.0,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Color.fromARGB(255, 112, 182, 182),
            ),
            onPressed: onToggleVisibility,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        ),
        validator: validator ??
            (value) => value!.isEmpty ? 'Please enter your $label' : null,
      ),
    );
  }
  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedRoleId,
        decoration: InputDecoration(
          labelText: "Select Role",
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 112, 182, 182),
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 239, 247, 247),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 112, 182, 182),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 112, 182, 182),
              width: 2.0,
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
        validator: (value) => value == null ? 'Please select a role' : null,
      ),
    );
  }
}*/


