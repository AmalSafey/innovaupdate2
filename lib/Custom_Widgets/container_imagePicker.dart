

import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  final int imageNumber;
  final File? image;
  final bool isLarge;
  final Function(int) onImagePicked;

  const ImagePickerWidget({
    Key? key,
    required this.imageNumber,
    this.image,
    this.isLarge = false,
    required this.onImagePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onImagePicked(imageNumber),
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: isLarge ? 200 : 130,
        height: isLarge ? 270 : 130,
        decoration: BoxDecoration(
          color: Colors.grey[200], // استخدم اللون المناسب من Constants
          borderRadius: BorderRadius.circular(15),
        ),
        child: image != null
            ? Image.file(image!, fit: BoxFit.cover)
            : Icon(Icons.file_upload, size: isLarge ? 30 : 20),
      ),
    );
  }
}
