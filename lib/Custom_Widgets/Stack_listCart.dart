import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/quick_alert.dart';
import 'package:innovahub_app/core/Api/cart_services.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/home/widget/favorite_icon_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';

// Carpets products:
// ignore: camel_case_types, must_be_immutable
class stacklistcart extends StatefulWidget {
  stacklistcart({super.key, required this.product});

  ProductResponse product; // object from model to represent data:

  @override
  State<stacklistcart> createState() => _stacklistcartState();
}

// ignore: camel_case_types
class _stacklistcartState extends State<stacklistcart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          height: 330,
          width: 260,
          decoration: BoxDecoration(
            color: Constant.whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Image.network(
                widget.product.productImage,
                fit: BoxFit.cover,
                height: 160,
                width: 160,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text("Made by ",
                          style: TextStyle(fontSize: 13, color: Colors.black)),
                      Text(widget.product.authorName,
                          style: const TextStyle(
                              fontSize: 13, color: Constant.blueColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${widget.product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Constant.blackColorDark),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      FavoriteIconButton(product: widget.product),
                      const SizedBox(width: 15),
                      InkWell(
                        onTap: () {
                          addToCart(widget.product.productId, 1).then((value) {
                            if (value) {
                              quickAlert(
                                  context: context,
                                  title: "Added to cart successfully",
                                  type: QuickAlertType.success);
                            } else {
                              quickAlert(
                                  context: context,
                                  title: "Error adding to cart",
                                  type: QuickAlertType.error);
                            }
                          });
                        },
                        child: const Icon(Icons.shopping_cart),
                      ),
                      const SizedBox(width: 40),
                      const CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text("In stock",
                          style: TextStyle(
                              fontSize: 13, color: Constant.blackColorDark)),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        widget.product.stock.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
