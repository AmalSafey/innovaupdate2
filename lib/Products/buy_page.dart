
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovahub_app/Custom_Widgets/shipping%20_address_container.dart';
import 'package:innovahub_app/Products/checkout_address.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/payment/view/payment_view.dart';

/*class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  static const String routeName = 'buy_page'; // route name:

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
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
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, CheckoutAddress.routeName);
              },
              child: const ShippingAddressContainer()),
          const SizedBox(height: 15),
          Container(
            height: 250,
            // width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 4)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          //color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/owner.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text("Owner Name",
                          style: TextStyle(
                              color: Constant.blackColorDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    color: Constant.greyColor2,
                    thickness: 1.5,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
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
                              const Text(
                                  'Lapis Set, Necklace, ring, earrings lightweight',
                                  style: TextStyle(
                                      color: Constant.blackColorDark,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('\$28.00',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87)),
                                  const SizedBox(
                                      width: 4), // إضافة مسافة قبل الأيقونة
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Constant.whiteColor,
                                      border: Border.all(
                                        color: Constant.greyColor2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
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
                                  const SizedBox(
                                      width: 3), // إضافة مسافة قبل الأيقونة
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Constant.whiteColor,
                                        border: Border.all(
                                          color: Constant.greyColor2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: IconButton(
                                        icon: const FaIcon(
                                            FontAwesomeIcons.trash,
                                            color: Constant.redColor),
                                        onPressed: () {
                                          setState(() {
                                            quantity = 0;
                                          });
                                        },
                                      ),
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
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // todo get api 
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PaymetExcuteWebView(
                          url: "https://www.google.com",
                        )));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.mainColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            minimumSize: const Size(220, 50),
          ),
          child: const Text('Buy Now ',
              style: TextStyle(fontSize: 18, color: Constant.whiteColor)),
        ),
      ),
    );
  }
}*/
