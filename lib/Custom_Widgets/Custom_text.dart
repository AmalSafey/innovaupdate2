
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class TextCategory extends StatelessWidget {
   TextCategory({super.key,required this .label});

  String label ;
  
  @override
  Widget build(BuildContext context) {
    return Text(label,
    
    style: const TextStyle(
      color: Constant.blackColorDark,
      fontSize: 14,

    ),
    
    );
  }
}

