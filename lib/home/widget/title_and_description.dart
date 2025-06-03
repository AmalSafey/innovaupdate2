import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class TitleAndDescription extends StatelessWidget {
  final String title;
  final String description;
  const TitleAndDescription({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Constant.mainColor),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            description,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Constant.blackColorDark),
            maxLines: 2,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}