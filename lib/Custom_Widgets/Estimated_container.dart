
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';

class EstimatedContainer extends StatelessWidget {
  const EstimatedContainer({super.key});

  
  @override
  Widget build(BuildContext context) {
    return  Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Constant.white5Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Balance', // text:
                      style: TextStyle(
                        color: Constant.blackColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' EGP', // text:
                      style: TextStyle(
                        color: Constant.purpuleColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '≈ \$0', // text:
                      style: TextStyle(
                        color: Constant.blackColorDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                /*Column(
                  children: [
                   /* Container(
                      //margin: EdgeInsets.only(left: 30),
                      //padding: const EdgeInsets.only(left: 10, right: 10),
                      width: 90,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Constant.blueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Withdraw',
                          style: TextStyle(
                            color: Constant.whiteColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),*/
                    
                    const SizedBox(
                      height: 15,
                    ),
                   
                    Container(
                      //margin: EdgeInsets.only(left: 30),
                      //padding: const EdgeInsets.only(left: 10, right: 10),
                      width: 90,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Constant.blueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Deposit',
                          style: TextStyle(
                            color: Constant.whiteColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          );


  }    
                  
}



/*

Container(
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/owner1.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    
                     const SizedBox( width: 8,),
                    
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                        'Mohamed Ali',
                        style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                       ),
                      ),
                      
                         //SizedBox(  height: 5,),

                         Text(
                        'ID:2333669591',
                         style: TextStyle(
                         color: Constant.greyColor,
                         fontSize: 15,
                       ),
                      ),
                       
                        //SizedBox(  height: 5,),

                         Row(
                          children: [
                             CircleAvatar(
                            radius: 8,
                            backgroundColor: Constant.blue3Color,
                            child: Icon(
                              Icons.check,
                              color: Constant.whiteColor,
                              size: 14,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Constant.greyColor3,
                              fontSize: 13,
                            ),
                          ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    
                    const Text(
                      "7:57 Am 1/23/2025",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
           
            Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Text(
                  "Business Name : ",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Aqua-Candels ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            
            const Row(
              children: [
                Text(
                  "Business Type : ",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Home accessories",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              " Descriptions ",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            const Text(
              " Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed doeiusmod tempor incididunt ut labore et dolore magna aliquaLorem ipsum dolor sit amet, consectetur adipisicing elit. ",
            ),
            const Row(
              children: [
                Text(
                  "Offer Money : ",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Text(
                  "10,000EGP ",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: [
                Text(
                  "Offer Deals : ",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Text(
                  "20% of total project",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/photo1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
             
               const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Container(
                      height: 90,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/images/photo2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 90,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/images/photo3.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: const Center(
                          child: Text(
                        "Accept Offer",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ))),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: const Center(
                          child: Text(
                        "Discuss Offer",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                ))),


                ),


              ],
            )
          ],

*/