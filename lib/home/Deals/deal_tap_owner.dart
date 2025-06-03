
import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/deal_owner_card.dart';
import 'package:innovahub_app/Models/Deals/Business_owner_response.dart';
import 'package:innovahub_app/core/Api/Api_Manager_deals.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/add_Tap_owner.dart';
import 'package:innovahub_app/home/widget/custom_search_bar.dart';

class DealOwner extends StatelessWidget {
  const DealOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              const CustomSearchBar(),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(13),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
          ),
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Constant.white2Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                
                Navigator.pushNamed(context, PublishDealScreen.routeName);

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Publish New Deal              ', // text:
                    style: TextStyle(
                      color: Constant.blackColorDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Constant.mainColor, // لون الـ border
                        width: 3, // سمك الـ border
                      ),
                    ),
                    child: const CircleAvatar(
                        backgroundColor: Constant.whiteColor,
                        radius: 15,
                        child: Icon(
                          Icons.add,
                          color: Constant.mainColor,
                          size: 30,
                        )),
                  ), // Icon:
                ],
              ),
            ),
          ),
          const SizedBox( height: 5,),
          
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Text(
              'Recent Published Deals ',
              style: TextStyle(
                  color: Constant.blackColorDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),

            const SizedBox(height: 16),


            FutureBuilder<List<BusinessOwnerResponse>>(
              future:ApiManagerDeals.getAllDeals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Constant.mainColor,));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No deals found."));
                }

                final deals = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: deals.length,
                  itemBuilder: (context, index) {
                    return DealCard(deal: deals[index]);
                    
                  },
                );
              },
            ),
          ],
        ),
      ),

      
    );
  }
}

