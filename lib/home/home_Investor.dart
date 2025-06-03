import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Api/Api_investor_home_.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/Custom_Widgets/Estimated_container.dart';
import 'package:innovahub_app/Custom_Widgets/container_investor.dart';

class HomeInvestor extends StatelessWidget {
  const HomeInvestor({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            color: Constant.mainColor,
          ),
          const SizedBox(  height: 15, ),
          
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Constant.whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Image.asset(
                  "assets/images/owner1.png",
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mohamed Ali',
                        style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Constant.blue3Color,
                            child: Icon(
                              Icons.check,
                              color: Constant.whiteColor,
                              size: 18,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Constant.greyColor3,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID:2333669591',
                      style: TextStyle(
                        color: Constant.greyColor,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
    
              ],
            )
          ),



          /*Container(
            margin: const EdgeInsets.only(top: 6),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Constant.mainColor,
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                fillColor: Constant.whiteColor,
                filled: true,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Constant.greyColor2,
                ),
                hintText: 'Search any Product...',
                hintStyle:
                    const TextStyle(color: Constant.greyColor2, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Constant.whiteColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Constant.whiteColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Constant.whiteColor),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/investor1.png",
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mohamed Ali',
                        style: TextStyle(
                          color: Constant.blackColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Constant.blue3Color,
                            child: Icon(
                              Icons.check,
                              color: Constant.whiteColor,
                              size: 18,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Verified',
                            style: TextStyle(
                              color: Constant.greyColor3,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID:2333669591',
                      style: TextStyle(
                        color: Constant.greyColor,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),*/

          const EstimatedContainer(),
          
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              'Track your investments',
              style: TextStyle(
                  color: Constant.blackColorDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
            FutureBuilder<List<InvestorInvestment>>(
            future: fetchInvestorInvestments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding:const  EdgeInsets.all(20),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }

              final investments = snapshot.data!;

              if (investments.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No investments for this investor',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }

              return Column(
                children: investments.map((investment) {
                  return ContainerInvestor(investment: investment);
                }).toList(),
              );
            },
          ),
          
          const SizedBox(height: 20,),



        ],
      ),
    );
  }
}


