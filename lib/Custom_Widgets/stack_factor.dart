

import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/Category_response.dart';

class stackrefactor extends StatelessWidget {
  CategoryResponse catigory;
  stackrefactor({super.key, required this.catigory});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 170,
          width: 120,
          child: Image.network(catigory.imageUrl),
        ),
        Positioned(
          bottom: 50,
          left: 30,
          child: Container(
              width: 60,
              decoration: BoxDecoration(
                // Semi-transparent background for visibility
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  catigory.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        )
      ],
    );
  }
}