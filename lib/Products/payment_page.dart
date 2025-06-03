
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:innovahub_app/Custom_Widgets/shipping_address_container.dart';
import 'package:innovahub_app/home/cart_Tap.dart';
import 'package:innovahub_app/home/user_home_screen.dart';
import 'package:innovahub_app/payment/view/payment_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:innovahub_app/Products/checkout_address.dart';
import 'package:innovahub_app/core/Api/Api_delivery_method.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';


 class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  static const String routeName = 'payment_page'; // route name:

  @override
  State<PaymentPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<PaymentPage> {
  int select = 0;
  int quantity = 1;
  List<DeliveryMethod> deliveryMethods = [];
  DeliveryMethod? selectedMethod;
  bool isLoading = true;
  String? userComment = "No comment provided";

  @override
  void initState() {
    super.initState();
    fetchDeliveryMethods();
    fetchComment();
  }

  Future<void> fetchComment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userComment = prefs.getString("userComment") ?? "No comment provided";
    });
  }

  Future<void> fetchDeliveryMethods() async {
    try {
      List<DeliveryMethod> methods =
          await DeliveryService.fetchDeliveryMethods();
      setState(() {
        deliveryMethods = methods;
        if (deliveryMethods.isNotEmpty) {
          selectedMethod = deliveryMethods.first;
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching delivery methods: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> confirmOrder({
    required int deliveryMethodId,
    required String userComment,
  }) async {
    const String apiUrl =
        "https://innova-hub.premiumasp.net/api/order/Confirm-Order";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        print("Error: No token found. Please log in again.");
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "DeliveryMethodId": deliveryMethodId,
          "UserComment": userComment,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("Order confirmed successfully!");

        if (responseData.containsKey("RedirectToCheckoutUrl")) {
          await launchCheckoutUrl(responseData["RedirectToCheckoutUrl"]);
        }
      } else {
        var responseBody = jsonDecode(response.body);
        print(
            "Failed to confirm order: ${responseBody['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print("Error confirming order: $e");
    }
  }

  Future<void> launchCheckoutUrl(String url) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return PaymetExcuteWebView(url: url);
      }),
    );

    if (result == "success") {
      // Navigate to Home after payment success
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserHomeScreen.routeName,
        (route) => false,
      );
    } else if (result == "failed") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment failed, please try again.")),
      );
    }
  }

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
      body:SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, CheckoutAddress.routeName);
                },
                child: const ShippingAddressWidget()),
            const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListWidget()),
            Container(
              height: 350,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 4)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      'Delivery Methods',
                      style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const CircularProgressIndicator(color: Constant.mainColor,)
                      : deliveryMethods.isNotEmpty
                          ? Column(
                              children: deliveryMethods.map((method) {
                                return RadioListTile<DeliveryMethod>(
                                  title: Text(
                                      "${method.shortName} - \$${method.cost}"),
                                  subtitle: Text(method.description),
                                  value: method,
                                  groupValue: selectedMethod,
                                  fillColor: MaterialStateProperty.all(Constant.mainColor),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMethod = value;
                                    });
                                  },
                                );
                              }).toList(),
                            )
                          : const Text("No delivery methods available."),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 220,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Constant.whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order summary',
                      style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 130,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Constant.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Constant.greyColor4),
                      ),
                     /* child: const Text("Add your comment...",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Constant.greyColor4,
                          fontSize: 15,
                        ),
                      ),*/
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
                height: 180,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Constant.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(
                                    color: Constant.greyColor4,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "\$${CartController.calculateTotalCartPrice().toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Constant.mainColor),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                'Shipping',
                                style: TextStyle(
                                    color: Constant.greyColor4,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              
                              Text(
                                "\$15.00",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Constant.mainColor),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                'Taxs',
                                style: TextStyle(
                                    color: Constant.greyColor4,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "\$2.00",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Constant.mainColor),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Constant.greyColor4,
                            thickness: 1.5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                    color: Constant.greyColor4,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "\$${((CartController.calculateTotalCartPrice() + 15) * 1.02).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Constant.mainColor,
                                ),
                              ),
                            ],
                          ),
                        ]))),
                const SizedBox(height: 30,  ),
             Padding(
               padding: const EdgeInsets.all(16),
               child: ElevatedButton(
                onPressed: () async {
                  if (selectedMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select a delivery method!")),
                    );
                    return;
                  }
               
                  await confirmOrder(
                    deliveryMethodId: selectedMethod!.id,
                    userComment: userComment!,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.mainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(220, 50),
                ),
                child: const Text('Buy Now',
                    style: TextStyle(fontSize: 18, color: Constant.whiteColor)),
                           ),
             ),
            const SizedBox( height: 20,),
          ],
        ),
      ),
    );
  }
}
















/*class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  static const String routeName = 'payment_page'; // route name:

  @override
  State<PaymentPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<PaymentPage> {
  int select = 0;
  int quantity = 1;
  List<DeliveryMethod> deliveryMethods = [];
  DeliveryMethod? selectedMethod;
  bool isLoading = true;
  String? userComment = "No comment provided";

  @override
  void initState() {
    super.initState();
    fetchDeliveryMethods();
    fetchComment();
  }

  Future<void> fetchComment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userComment = prefs.getString("userComment") ?? "No comment provided";
    });
  }

  Future<void> fetchDeliveryMethods() async {
    try {
      List<DeliveryMethod> methods =
          await DeliveryService.fetchDeliveryMethods();
      setState(() {
        deliveryMethods = methods;
        if (deliveryMethods.isNotEmpty) {
          selectedMethod = deliveryMethods.first;
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching delivery methods: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> confirmOrder({
    required int deliveryMethodId,
    required String userComment,
  }) async {
    const String apiUrl =
        "https://innova-hub.premiumasp.net/api/order/Confirm-Order";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        print("Error: No token found. Please log in again.");
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "DeliveryMethodId": deliveryMethodId,
          "UserComment": userComment,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("Order confirmed successfully!");

        if (responseData.containsKey("RedirectToCheckoutUrl")) {
          await launchCheckoutUrl(responseData["RedirectToCheckoutUrl"]);
        }
      } else {
        var responseBody = jsonDecode(response.body);
        print(
            "Failed to confirm order: ${responseBody['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print("Error confirming order: $e");
    }
  }

Future<void> launchCheckoutUrl(String url) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return PaymetExcuteWebView(url: url);
    }),
  );

  if (result == "success") {
    // Navigate to Home after payment success
    Navigator.pushNamedAndRemoveUntil(
      context,
      UserHomeScreen.routeName, 
      (route) => false,
    );
  } else if (result == "failed") {
    // في حالة فشل الدفع، يمكنك عرض رسالة فشل
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment failed, please try again.")),
    );
  }
}



  /*Future<void> launchCheckoutUrl(String url) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PaymetExcuteWebView(url: url);
      
    }));
    // final Uri uri = Uri.parse(url);
    // if (!await launchUrl(uri)) {
    //   print('❌ Could not launch $url');
    // }
  }*/

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
      body: SingleChildScrollView(
        child: Column(
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
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                                    /* Expanded(
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
                                    ),*/
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
            Container(
              height: 350,
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 4)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      'Delivery Methods',
                      style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const CircularProgressIndicator()
                      : deliveryMethods.isNotEmpty
                          ? Column(
                              children: deliveryMethods.map((method) {
                                return RadioListTile<DeliveryMethod>(
                                  title: Text(
                                      "${method.shortName} - \$${method.cost}"),
                                  subtitle: Text(method.description),
                                  value: method,
                                  groupValue: selectedMethod,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMethod = value;
                                    });
                                  },
                                );
                              }).toList(),
                            )
                          : const Text("No delivery methods available."),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 230,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Constant.whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 140,
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Constant.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Constant.greyColor4),
                      ),
                      child: const Text(
                        "Add your comment...",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Constant.greyColor4,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedMethod == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                    content: Text("Please select a delivery method!")),
                  );
                  return;
                }

                await confirmOrder(
                  deliveryMethodId: selectedMethod!.id,
                  userComment: userComment!,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Constant.mainColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                minimumSize: const Size(220, 50),
              ),
              child: const Text('Buy Now',
                  style: TextStyle(fontSize: 18, color: Constant.whiteColor)),
            ),
            const SizedBox(
              height: 20,
            ),

            /* const Spacer(),
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
                child: const Text('Buy Now ',
                style: TextStyle(fontSize: 18, color: Constant.whiteColor)),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}*/


