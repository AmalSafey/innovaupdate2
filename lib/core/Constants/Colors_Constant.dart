
import 'package:flutter/material.dart';

// Colors that used in tha App:
class Constant {
  //Color.fromARGB(255, 63, 154, 152);

  static const Color mainColor = Color(0xFF126090);
  static const Color blackColorDark = Color(0xFF000000);
  static const Color blackColor = Color(0xFF222222);
  static const Color greyColor = Color(0xFF888888);
  static const Color greyColor2 = Color(0xFFB2B1B1);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color greyColor3 = Color(0xFF333333);
  static const Color blueColor = Color(0xFF0056B3);
  static const Color transparentColor = Color(0xFFedf1f3);
  static const Color blue2Color = Color(0xFF2F35ED);
  static const Color purpuleColor = Color(0xFF2C1DB3);
  static const Color blue3Color = Color(0xFF0000FF);
  static const Color white2Color = Color(0xFFf2f2f2);
  static const Color greenColor = Color(0xFF1ABA1A);
  static const Color greyColor4 = Color(0xFF999999);
  static const Color yellowColor = Color(0xFFF5C301);
  static const Color white3Color = Color(0xFFF7F7F7);
  static const Color redColor = Color(0xFFFF0000);
  static const Color white4Color = Color(0xFFD9D9D9);
  static const Color black2Color = Color(0xFF545454);
  static const Color black3Color = Color(0xFF4B4A4A);
  static const Color green2Color = Color(0xFF6BB76B);
  static const Color white5Color = Color(0xFFEEF3FF);
}

/*

class _RegisterDesignState extends State<RegisterScreen> {
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
  String? selectedRole;
  bool isLoading = false;
  String? errorMessage;

  final _formKey = GlobalKey<FormState>(); // key of form:

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(), // to initialize AuthCubit:
      child: BlocConsumer<AuthCubit, AuthStates>(listener: (context, state) {
        if (state is RegisterSuccessState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
        } else if (state is RegisterErrorStata) {
          // show an error message:
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 10),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }, builder: (context, state) {
        // to build UI:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Row(
              children: [
                //Icon(Icons.arrow_back),
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
                
                    const SizedBox(height: 20),
                
                
                    TextFieldWidget(
                      controller: firstnameController,
                      label: 'First Name',
                      hint: 'Enter Your First Name',
                    ),
                
                    const SizedBox(height: 15),
                
                    TextFieldWidget(
                      controller: lastnameController,
                      label: 'Last Name',
                      hint: 'Enter Your Last Name',
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
                          contentPadding: const EdgeInsets.all(14), // تقليل المسافة داخل الـ TextField
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
                            borderSide: BorderSide(color: Constant.greyColor2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Constant.greyColor2),
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
                    TextFieldWidget(
                      controller: phoneNumberController,
                      label: 'Phone Number',
                      hint: 'Enter Your Phone Number',
                      isPhone: true,
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      controller: countryController,
                      label: 'Country',
                      hint: 'Enter Your Country',
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      controller: cityController,
                      label: 'City',
                      hint: 'Enter Your City',
                    ),
                    const SizedBox(height: 15),
                    TextFieldWidget(
                      controller: districtController,
                      label: 'District',
                      hint: 'Enter Your District',
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Select Role",
                          labelStyle: const TextStyle(
                              color: Color(0xFF333333), fontSize: 15),
                          hintText: "Choose one",
                          suffixIcon: DropdownButton<String>(
                            items: ["User", "Investor", "Owner"]
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRole = value;
                              });
                            },
                            underline:
                                const SizedBox(), // Removes the default underline
                            icon: const Icon(
                                Icons.arrow_drop_down), // Dropdown arrow icon
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:const BorderSide(color: Constant.greyColor2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:
                                const BorderSide(color: Constant.greyColor2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Constant.greyColor2),
                          ),
                        ),
                        controller: TextEditingController(text: selectedRole),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.black),
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {

                          validateForm();

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constant.mainColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 13.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
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
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
      }),
    );
  }  */
