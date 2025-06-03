

import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class ShippingAddressContainer extends StatelessWidget {
  const ShippingAddressContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
            height: 70,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Constant.mainColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Constant.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Constant.mainColor,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'Add your shipping Address',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const Icon(
                  Icons.edit,
                  color: Constant.whiteColor,
                  size: 20,
                ),
              ],
            ),
          );
  }
}