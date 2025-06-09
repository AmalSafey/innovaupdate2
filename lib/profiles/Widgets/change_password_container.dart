
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class ChangePasswordContainer extends StatelessWidget {
  const ChangePasswordContainer({super.key,required this.oldPasswordController,required this.newPasswordController,required this.onChangePassword});
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 10, right: 8),
      height: 380,
      width: 380,
      decoration: BoxDecoration(
        color: Constant.white3Color,
        border: Border.all(width: 1, color: Constant.greyColor2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.password, color: Constant.mainColor),
                SizedBox(width: 5),
                Text(
                  "Change password",
                  style:
                      TextStyle(fontSize: 20, color: Constant.blackColorDark),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter your Old Password',
              style: TextStyle(
                  color: Constant.greyColor2,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Constant.greyColor2),
                filled: true,
                fillColor: Constant.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Constant.greyColor2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Constant.greyColor2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: Constant.greyColor2, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Enter your New Password',
              style: TextStyle(
                  color: Constant.greyColor2,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Constant.greyColor2),
                filled: true,
                fillColor: Constant.whiteColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Constant.greyColor2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Constant.greyColor2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: Constant.greyColor2, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Forgot Password?',
              style: TextStyle(
                  color: Constant.redColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                onChangePassword();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Constant.mainColor,
              ),
              child: const Text(
                "Change Password",
                style: TextStyle(color: Constant.whiteColor, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
