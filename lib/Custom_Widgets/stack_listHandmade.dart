import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/quick_alert.dart';
import 'package:innovahub_app/core/Api/cart_services.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/home/widget/favorite_icon_widget.dart';
import 'package:quickalert/models/quickalert_type.dart';

// ignore: must_be_immutable, camel_case_types
class stacklisthandmade extends StatefulWidget {
  stacklisthandmade({super.key, required this.product});

  ProductResponse product; // object from model to represent data:

  @override
  State<stacklisthandmade> createState() => _stacklisthandmadeState();
}

// ignore: camel_case_types
class _stacklisthandmadeState extends State<stacklisthandmade> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        //margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        height: 330,
        width: 230,
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(
          widget.product.productImage,
          fit: BoxFit.cover,
          height: 180,
          width: 230,
        ),
      ),
      Positioned(
        bottom: 40,
        left: 10,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.name,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 8,
            ),
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
            const SizedBox(
              height: 8,
            ),
              Text("\$${widget.product.price.toStringAsFixed(2)}",style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                FavoriteIconButton(product: widget.product),
                const SizedBox(
                  width: 15,
                ),
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
                const SizedBox(
                  width: 30,
                ),
                const CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    color: Constant.whiteColor,
                    size: 14,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
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
      )
    ]);
  }
}
