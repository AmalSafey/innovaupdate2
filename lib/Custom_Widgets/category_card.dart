import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/Category_response.dart';

// ignore: must_be_immutable
class CategoryCard extends StatelessWidget {
  CategoryCard({super.key, required this.category});

  CategoryResponse category; // object from Model:

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5),
          clipBehavior: Clip.antiAlias,           // to make image has rounded corners: 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          height: 110,
          width: 110,
          child: Image.network(
            category.imageUrl,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          bottom: 25,
          left: 25,
          child: Container(
              width: 60,
              decoration: BoxDecoration(
                // Semi-transparent background for visibility
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ),
      ],
    );
  }
}

