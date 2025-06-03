

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class CartItemWidget extends StatefulWidget {
   const CartItemWidget({super.key});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 360,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/Necklace3.png',
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Lapis Set, Necklace, ring, earrings lightweight',
                      style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('\$28.00',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Constant.whiteColor,
                          border: Border.all(
                            color: Constant.greyColor2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:Row(
                        children: [
                          IconButton(
                              icon: const Icon(
                                Icons.remove,
                                color: Constant.mainColor,
                                size: 25,
                              ),
                              onPressed: () {}),
                          Text('$quantity',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Constant.mainColor,
                              )),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Constant.mainColor,
                              size: 25,
                            ),
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                      ),

                   Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Constant.whiteColor,
                      border: Border.all(
                        color: Constant.greyColor2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                            icon: const FaIcon(FontAwesomeIcons.trash, color: Constant.redColor),
                            onPressed: () {
                              setState(() {
                                quantity = 0;
                              });
                            },
                          ),
                  ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

