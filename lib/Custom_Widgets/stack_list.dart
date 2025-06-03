import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/quick_alert.dart';
import 'package:innovahub_app/core/Api/cart_services.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/home/widget/favorite_icon_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';

// ignore: camel_case_types
class stacklist extends StatefulWidget {
  final ProductResponse product;

  const stacklist({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _StackListState createState() => _StackListState();
}

class _StackListState extends State<stacklist> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          height: 340,
          width: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
        ),
        Positioned(
          left: 35,
          child: Image.network(
            widget.product.productImage,
            fit: BoxFit.contain,
            height: 180,
            width: 180,
          ),
        ),
        Positioned(
          bottom: 10,
          left: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.product.name, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text("Made by ",
                      style: TextStyle(
                          fontSize: 13, color: Constant.blackColorDark)),
                  Text(widget.product.authorName,
                      style: const TextStyle(
                          fontSize: 13, color: Constant.blueColor)),
                ],
              ),
              const SizedBox(height: 8),
              Text("\$${widget.product.price.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.w500,
              color: Constant.blackColorDark),),
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
                  /*GestureDetector(
                    onTap: () async {
                      bool success = await addToCart(widget.product.productId, 1);ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: success ? Constant.mainColor : Colors.red,
                          content: Text(success
                              ? "${widget.product.name} added to cart 🛒"
                              : "Failed to add to cart"),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Icon(Icons.shopping_cart, color: Colors.black),
                  ),*/

                  const SizedBox(width: 50),
                  const CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.green,
                    child:
                        Icon(Icons.check, color: Constant.whiteColor, size: 14),
                  ),
                  const SizedBox(width: 5),
                 const Text("In stock",
                      style: TextStyle(
                          fontSize: 13, color: Constant.blackColorDark)),
                 const  SizedBox(
                    width: 2,
                  ),
                  Text(
                    widget.product.stock.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              /* Row(
                children: [
                  /*Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  Icon(Icons.star, color: Colors.yellow),
                  SizedBox(width: 8),*/
                  Text(
                    widget.product.stock.toString(),
                  ),
                ],
              ),*/
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
