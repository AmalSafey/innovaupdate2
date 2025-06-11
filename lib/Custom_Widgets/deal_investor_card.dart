import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/Deals/Business_owner_response.dart';
import 'package:innovahub_app/core/Api/Api_For_Accept.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/Deals/disscussoffer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DealCardInvestor extends StatelessWidget {
  final BusinessOwnerResponse deal;

  const DealCardInvestor({super.key, required this.deal});

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Offer Status"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Images: \${deal.images}");

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                  radius: 25,
                  backgroundColor: Constant.greyColor2,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Constant.greyColor3,
                  )),
              const SizedBox(width: 1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deal.businessownerName,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Constant.blackColorDark)),
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: Constant.blue3Color,
                        child: Icon(Icons.check,
                            color: Constant.whiteColor, size: 14),
                      ),
                      SizedBox(width: 16),
                      Text("Verified",
                          style: TextStyle(
                              fontSize: 13, color: Constant.greyColor3))
                    ],
                  )
                ],
              ),
              const Spacer(),
              Text(deal.approvedAt,
                  style: const TextStyle(
                      fontSize: 14, color: Constant.greyColor4)),
            ],
          ),
          const SizedBox(height: 15),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Business Name: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constant.mainColor,
                  ),
                ),
                TextSpan(
                  text: deal.businessName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Constant.blackColorDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Business Type: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constant.mainColor,
                  ),
                ),
                TextSpan(
                  text: deal.categoryName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Constant.blackColorDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text("Description",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Constant.mainColor)),
          const SizedBox(height: 4),
          Text(
            deal.description,
            style: const TextStyle(
              color: Constant.black3Color,
            ),
          ),
          const SizedBox(height: 8),
          Text("Offer Money: \${deal.offerMoney} EGP",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Constant.mainColor)),
          const SizedBox(height: 4),
          Text("Offer Deal: \${deal.offerDeal}%",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Constant.mainColor)),
          const SizedBox(height: 10),
          if (deal.images.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    deal.images[0],
                    width: 190,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: deal.images.skip(1).take(2).map((img) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          img,
                          width: 150,
                          height: 95,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  final result =
                      await AcceptService.acceptOffer(dealId: deal.dealid);

                  // Debug log (optional)
                  print("Accept result: $result");

                  // Show backend message
                  _showAlert(context, result['message']);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 6, top: 15),
                  padding: const EdgeInsets.all(12),
                  width: 190,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Accept Offer",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt("DealId", deal.dealid);

                  Navigator.pushNamed(context, Disscussoffer.routname);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 15),
                  padding: const EdgeInsets.all(12),
                  width: 150,
                  decoration: BoxDecoration(
                    color: Constant.yellowColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: const Center(
                          child: Text(
                        "Discuss Offer",
                        style:
                            TextStyle(fontSize: 18, color: Constant.whiteColor),
                      ))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
