
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class PrivacyOwnerInvestor extends StatelessWidget {
  const PrivacyOwnerInvestor({super.key});

  static const String routeName = 'privacy_owner';             // routeName of this screen:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // backgroundColor: Colors.white,
        centerTitle: true,
        title: const Row(
         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 20,),
            Icon(
              Icons.verified_user,
              color: Constant.mainColor,
              size: 25,
            ),
            SizedBox(width: 15,),
             Text("Privacy & Security",
              style: TextStyle(
                color: Constant.blackColorDark,
                fontSize: 22,
              ),
            ),
          ],
        )
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
               Container(
                padding: const EdgeInsets.only(left: 8,top: 10,right: 8),
                  height: 340,
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
                              Icons.person_pin_outlined,
                              color: Constant.mainColor,
                              size: 30,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Identity Verification",
                              style: TextStyle(
                                fontSize: 20,
                                color: Constant.blackColorDark
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          children: [
                            Text(
                                'You must provide a valid and clear ID images. ',
                                style:TextStyle(
                                  color: Constant.greyColor4,
                                ),
                          ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text('Send ID Front and Back image.',
                            style:TextStyle(
                               color: Constant.greyColor4,
                            ), 
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text('Reviewing ID may take some time. ',
                              style:TextStyle(
                               color: Constant.greyColor4,
                          ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      color: Constant.white4Color,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Icon(Icons.upload_file),
                                ),
                                
                                const SizedBox(
                                  height: 5,
                                ),

                                const Text("Front ID Image",
                                 style: TextStyle(
                                  color: Constant.black2Color,
                                 ),
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: 130,
                                  decoration: BoxDecoration(
                                      color: Constant.white4Color,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: const Icon(Icons.upload_file),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text("Back ID Image",
                                style: TextStyle(
                                  color: Constant.black2Color,
                                ),
                                )
                              ],
                            ),
                          ],
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
                              "Send Images",
                              style:
                              TextStyle(color: Constant.whiteColor, fontSize: 18),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                 const SizedBox(
                  height: 15,
                ),

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

              const SizedBox(height: 15,),

              Container(
                padding: const EdgeInsets.only(left: 8,top: 15, right: 8),
                height: 150,
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
        ),
      ),

    );
  }
}