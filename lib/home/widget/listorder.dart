/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/Deals/add_Rating.dart';
import 'package:innovahub_app/home/cart_Tap.dart';

class MyWidget extends StatefulWidget {


  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Map<int, int> ratings = {};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: CartController.cartItems.length,
      itemBuilder: (context, index) {
        final item = CartController.cartItems[index];
        final currentRating = ratings[index] ?? 0;
        final int productId = item["ProductId"]; // تأكد من صحة المفتاح

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Container(
                height: 90,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(item["HomePictureUrl"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "How Find This Product",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return IconButton(
                          icon: Icon(
                            starIndex < currentRating
                                ? Icons.star
                                : Icons.star_border_outlined,
                            color: starIndex < currentRating
                                ? Colors.amber
                                : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () async {
                            final ratingValue = starIndex + 1;

                            setState(() {
                              ratings[index] = ratingValue;
                            });

                            await sendProductRating(RatingModel(
                              productId: productId,
                              ratingValue: ratingValue,
                            ));
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/cart_Tap.dart';

class MyWidget extends StatefulWidget {
    final ProductResponse product;

  const MyWidget({required this.product});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // Map to store ratings per item (using index as key)
  Map<int, int> ratings = {};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: CartController.cartItems.length,
      itemBuilder: (context, index) {
        final item = CartController.cartItems[index];
        final currentRating = ratings[index] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Container(
                height: 90,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(
                      item["HomePictureUrl"],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How Find This Product",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return IconButton(
                          icon: Icon(
                            starIndex < currentRating
                                ? Icons.star
                                : Icons.star_border_outlined,
                            color: starIndex < currentRating
                                ? Colors.amber
                                : Colors.grey,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              ratings[index] = starIndex + 1;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/cart_Tap.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: CartController.cartItems.length,
      itemBuilder: (context, index) {
        final item = CartController.cartItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Container(
                height: 90,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(
                      item["HomePictureUrl"],
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How Find This Product",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(children: [
                      Icon(Icons.star_border_outlined, size: 30),
                      Icon(Icons.star_border_outlined, size: 30),
                      Icon(Icons.star_border_outlined, size: 30),
                      Icon(Icons.star_border_outlined, size: 30),
                      Icon(Icons.star_border_outlined, size: 30),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
*/
