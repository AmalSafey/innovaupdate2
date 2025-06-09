
import 'package:flutter/material.dart';
import 'package:innovahub_app/Models/Deals/Business_owner_response.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class DealCardInvestor extends StatelessWidget {
  final BusinessOwnerResponse deal;

  const DealCardInvestor({super.key, required this.deal});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://innova-web-client-o9f2bm0yn-justmahmuds-projects.vercel.app/owner/Deals');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
   void acceptshowQuickAlertAndNavigate(BuildContext context) {
    QuickAlert.show(
      confirmBtnColor: Constant.mainColor,  
      context: context,
      type: QuickAlertType.info,
      title: 'Accepting process',
      text: 'Please Navigate to browser page to complete..',
      autoCloseDuration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 2), () {
      _launchURL();
    });
  }
    void discussshowAcceptAlert(BuildContext context) {
    QuickAlert.show(
      confirmBtnColor: Constant.mainColor,  
      context: context,
      type: QuickAlertType.info,
      title: 'Discussing process',
      text: 'Please Navigate to browser page to complete..',
      autoCloseDuration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 2), () {
      _launchURL();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Images: ${deal.images}");

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
              /*Image.asset(
                'assets/images/owner1.png',
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),*/
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(deal.businessownerName,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Constant.blackColorDark)),
                  /* Text("ID: ${deal.businessownerId}",
                      style: const TextStyle(
                          fontSize: 15, color: Constant.greyColor)),*/
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundColor: Constant.blue3Color,
                        child: Icon(Icons.check,
                            color: Constant.whiteColor, size: 14),
                      ),
                      SizedBox(width: 8),
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
          const SizedBox(
            height: 5,
          ),
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
          Text("Offer Money: ${deal.offerMoney} EGP",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Constant.mainColor)),
          const SizedBox(height: 4),
          Text("Offer Deal: ${deal.offerDeal}%",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Constant.mainColor)),
          const SizedBox(height: 10),
          if (deal.images.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12), // ← الزوايا
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
                onTap: () {
                acceptshowQuickAlertAndNavigate(context);

                },
                child: Container(
                  margin: const EdgeInsets.only(left: 6, top: 15),
                  padding: const EdgeInsets.all(12),
                  //height: 40,
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
                onTap: () {
                  discussshowAcceptAlert(context);
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
