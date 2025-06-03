import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Models/product_response.dart'; // تأكد من استيراد هذا

class ContainerUser extends StatelessWidget {
  const ContainerUser({
    super.key,
    required this.icon,
    required this.title,
    this.route,
    this.product,
  });

  final IconData icon;
  final String title;
  final String? route;
  final ProductResponse? product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Constant.mainColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: Constant.mainColor),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Constant.blackColorDark,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: route != null
              ? () => Navigator.pushNamed(
                    context,
                    route!,
                    arguments: product,
                  )
              : null,
        ),
      ),
    );
  }
}
