

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class PrivacyUser extends StatelessWidget {
  const PrivacyUser({super.key});
  
  static const String routeName = 'privacy_user';          // routeName of this screen:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Privacy & Security",
          style: TextStyle(
            color: Constant.blackColorDark,
            fontSize: 22,
          ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8,top: 10,right: 8),
                height: 220,
                width: 380,
                decoration: BoxDecoration(
                    color: Constant.white3Color,
                    border: Border.all(
                      width: 1,
                      color: Constant.greyColor2,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                 child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.password,
                            color: Constant.mainColor,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Change password",
                            style: TextStyle(fontSize: 20,color: Constant.blackColorDark),
                          ),
                        ],
                      ),
                     const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Enter your Email...",
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
                       
                        keyboardType: TextInputType.emailAddress, // Keyboard optimized for emails
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Constant.mainColor,
                          ),
                          child: const Text(
                            "Send Email",
                            style: TextStyle(color: Constant.whiteColor, fontSize: 18),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
             
              Container(
                padding: const EdgeInsets.only(left: 8,top: 25, right: 8),
                height: 170,
                width: 380,
                decoration: BoxDecoration(
                    color: Constant.white3Color,
                    border: Border.all(
                      width: 1,
                      color: Constant.greyColor2,
                    ),
                    borderRadius: BorderRadius.circular(25)),
                 child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                     const Row(
                        children: [
                          Icon(
                          FontAwesomeIcons.trashAlt,
                            color: Constant.redColor,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Account Deletion",
                            style: TextStyle(fontSize: 20, color: Constant.redColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Constant.mainColor,
                          ),
                          child: const Text(
                            "Delete Account",
                            style: TextStyle(color: Constant.whiteColor, fontSize: 18),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}