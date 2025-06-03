

import 'package:flutter/material.dart';
import 'package:innovahub_app/Products/checkout_address.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddressWidget extends StatefulWidget {
  const ShippingAddressWidget({super.key});

  @override
  State<ShippingAddressWidget> createState() => _ShippingAddressWidgetState();
}

class _ShippingAddressWidgetState extends State<ShippingAddressWidget> {
  String? address;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAddress();
  }

  // This function loads the address from SharedPreferences
  Future<void> loadAddress() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? street = prefs.getString("StreetAddress");
    String? city = prefs.getString("City");

    setState(() {
      address = (street != null && city != null)
          ? '$street, $city'
          : 'Adding Shipping Address'; // Shows this message if no address is saved.
      isLoading = false;
    });
  }

  // Function to navigate to the address editing page
  Future<void> goToAddOrEditAddressPage({required bool isEditing}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutAddress(isEditing: isEditing),
      ),
    );

    if (result == true) {
      loadAddress(); // Reload the address after adding or editing
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          goToAddOrEditAddressPage(isEditing: false), // To add a new address
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Constant.mainColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.location_on,
                color: Constant.mainColor,
                size: 35,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Text(
                      address ??
                          'Add Shipping Address', // Display address or fallback message
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            InkWell(
              onTap: () => goToAddOrEditAddressPage(
                  isEditing: true), // To edit the existing address
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}