

import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';


  // textField Custom Widget:

class TextFieldWidget extends StatelessWidget {

   TextEditingController controller = TextEditingController();
   void Function(String)? isChanged ;
   final String label;
   final String hint ;
   final bool obscureText  ;
   final bool isFirstName ;
   final bool isLastName ;
   final bool isEmail ;
   final bool isPassword;
   final bool isConfirmPassword;
   final bool isPhone;
   final bool isCountry;
   final bool isCity;
   final bool isDistrict;
   final IconButton? suffixIcon;
   
   String password = '';
   String confirmPassword = '';
   
   TextFieldWidget({super.key,required this.controller, required this.label, required this.hint,
       this.obscureText = false,
       this.isFirstName = false,
       this.isEmail = false,
       this.isPassword = false,
       this.isConfirmPassword = false,
       this.isLastName = false,
       this.isPhone = false,
       this.isCountry = false,
       this.isCity = false,
       this.isDistrict = false,
       this.isChanged,
       this.suffixIcon,

    }
    );
   
  @override
  Widget build(BuildContext context) {
    return Padding(
    padding:const EdgeInsets.only(left: 10,right: 10),
    child: TextFormField(
     
     // onChanged:isChanged,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
      contentPadding:const EdgeInsets.all(14), // تقليل المسافة داخل الـ TextField
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF333333),
          fontSize: 15
          ),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF333333),
    
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color:Color(0xFFB2B1B1),
          
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color:Constant.greyColor2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Constant.greyColor2),

        ),
        suffixIcon: suffixIcon,            // To make icon of password visivle:
      ),

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (isFirstName && !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
          return 'Please enter a valid firstname (letters only)';
        }
        if(isLastName && !RegExp(r'^[a-zA-Z]+$').hasMatch(value)){
          return 'Please enter a valid lastname (letters only)';
        }

        if( isCountry && !RegExp(r'^[a-zA-Z]+$').hasMatch(value)){
          return 'Please enter a valid country (letters only)';
         }
         if( isDistrict && !RegExp(r'^[a-zA-Z]+$').hasMatch(value)){
          return 'Please enter a valid district (letters only)';
         }
        
         if( isCity && !RegExp(r'^[a-zA-Z]+$').hasMatch(value)){
          return 'Please enter a valid city (letters only)';
         }

        if (isEmail &&!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
          .hasMatch(value)) {
          return 'Please enter your valid email';
        }

        if(isPassword && value.length < 8){
         
         return'password must be at least 8 chars';
        }

        /*if(isPassword && !!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)){

          return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character.';
        }*/
       
       /*if(isConfirmPassword && isConfirmPassword != isPassword){

        return 'passwords do not match';
       }*/
       
       /*if(isPassword && value == null || value.isEmpty){
          
       return 'Please enter a password';
       }*/

      
      
      if (isPhone &&!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
          .hasMatch(value)) {
          return 'phone number must be 11 digits';
        }
        return null;

      },
    ),
  );
}

}