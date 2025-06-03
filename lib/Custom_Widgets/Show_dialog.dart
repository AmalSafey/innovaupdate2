

import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class ShowDialog extends StatelessWidget {
   ShowDialog({super.key});
  
  String message = '';

 
  @override
  Widget build(BuildContext context) {

    return  AlertDialog(
      content: Text(
          message,
          style: const TextStyle(
            color: Constant.blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
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
      );
  
  }
}