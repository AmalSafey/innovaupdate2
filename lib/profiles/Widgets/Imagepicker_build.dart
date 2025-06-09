
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class ImagePickerBuild extends StatelessWidget {
  final String label;
  final File? image;
  final VoidCallback onTap;

  const ImagePickerBuild ({
    Key? key,
    required this.label,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 80,
            width: 130,
            decoration: BoxDecoration(
              color: Constant.white4Color,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(image!, fit: BoxFit.cover),
                  )
                : const Icon(Icons.upload_file, size: 40),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Constant.black2Color)),
      ],
    );
  }
}