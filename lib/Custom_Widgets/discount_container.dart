
import 'package:flutter/material.dart';

class DiscountContainer extends StatelessWidget {
  const DiscountContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                 width: double.infinity,
                height: 200,
                child: Image.asset(
                  "assets/images/image-12.png",
                  fit: BoxFit.fill,
                )
              ),
              const  Positioned(
                top: 30,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "50-40 % off",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      "Now in (product)",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      "All colours",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              )
            ],
          );
  }
}