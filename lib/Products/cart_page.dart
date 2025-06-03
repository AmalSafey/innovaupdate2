import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/cart_item_widget.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const String routeName = 'cart';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int select = 0;
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.white3Color,
      appBar: AppBar(
        //shadowColor: Constant.whiteColor,
        backgroundColor: Constant.whiteColor,
        elevation: 0,
        title: const Text(
          'Innova',
          style: TextStyle(
              color: Constant.blackColorDark,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/image-13.png'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('Shopping Cart',
                        style: TextStyle(
                            color: Constant.blackColorDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 2,
                    ),
                    Text('(1 items)',
                        style: TextStyle(
                            color: Constant.greyColor4,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Constant.whiteColor,
                    minimumSize: const Size(90, 25),
                    side: const BorderSide(
                        color: Constant.mainColor, width: 1.5), // Border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Clear',
                      style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
          if (quantity > 0) const CartItemWidget(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Constant.mainColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                minimumSize: const Size(220, 50),
              ),
              child: const Text('Checkout',
                  style: TextStyle(fontSize: 18, color: Constant.whiteColor)),
            ),
          ),
        ],
      ),
    );
  }
}
