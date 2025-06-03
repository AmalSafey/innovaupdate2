


import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class DataTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const DataTextField({
    super.key,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // هذا هو السطر اللي كان يعطيك الخطأ
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Constant.greyColor,
          fontSize: 16,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constant.greyColor4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constant.greyColor4,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Constant.greyColor4,
          ),
        ),
      ),
    );
  }
}
