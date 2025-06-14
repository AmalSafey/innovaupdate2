import 'package:flutter/material.dart';
import 'package:innovahub_app/Custom_Widgets/deal_investor_card.dart';
import 'package:innovahub_app/Models/Deals/Business_owner_response.dart';
import 'package:innovahub_app/Models/profiles/User_profile_model.dart';
import 'package:innovahub_app/core/Api/Api_Manager_deals.dart';
import 'package:innovahub_app/core/Api/Api_Manager_profiles.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/Deals/notificationpage.dart';
import 'package:innovahub_app/home/Deals/notificationpageforinvestor.dart';

class DealInvestor extends StatefulWidget {
  const DealInvestor({super.key});

  @override
  State<DealInvestor> createState() => _DealInvestorState();
}

class _DealInvestorState extends State<DealInvestor> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Constant.mainColor,
          ),
          //const CustomSearchBar(),

          const SizedBox(
            height: 15,
          ),

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
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Constant.greyColor2,
                  child: Image.asset('assets/images/investor1.png'),
                ),
                const SizedBox(width: 10),
                FutureBuilder<UserProfile>(
                  future: ApiManagerProfiles.fetchUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      UserProfile user = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${user.firstName} ${user.lastName}",
                                style: const TextStyle(
                                  color: Constant.blackColorDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              const CircleAvatar(
                                radius: 9,
                                backgroundColor: Constant.blue3Color,
                                child: Icon(
                                  Icons.check,
                                  color: Constant.whiteColor,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              const Text(
                                'Verified',
                                style: TextStyle(
                                  color: Constant.greyColor3,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          notificationpageforinvestor.routname);
                                    },
                                    child: Icon(
                                      Icons.notifications,
                                      color: Constant.mainColor,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          /*Text(
                            "${user.firstName} ${user.lastName}",
                            style: const TextStyle(
                              color: Constant.blackColorDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),*/
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Text(
                              "ID: ${user.roleId}",
                              softWrap: true,
                              style: const TextStyle(
                                color: Constant.greyColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Constant.mainColor,
                        ),
                      );
                    }
                  },
                ),
              ], // End of children of Row
            ),
          ),

          const SizedBox(
            height: 20,
          ),

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
          const SizedBox(
            height: 30,
          ),

          FutureBuilder<List<BusinessOwnerResponse>>(
            future: ApiManagerDeals.getAllDeals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Constant.mainColor,
                ));
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
                  return DealCardInvestor(deal: deals[index]);
                },
              );
            },
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
