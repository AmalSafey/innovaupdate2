

import 'package:flutter/material.dart';
//  static const String routeName = 'page';


class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});
   static const String routeName = 'page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 24),

              _buildPublishNewDealButton(),

              const SizedBox(height: 20),

              const Text(
                'Recent Published Deals',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildDealsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: const NetworkImage(
            'https://randomuser.me/api/portraits/men/32.jpg',
          ),
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mohamed Ali',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          '23335565991',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPublishNewDealButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Publish New Deal',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.add,
              color: Colors.blue[600],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealsList() {
    return ListView(
      children: [
        _buildDealCard(
          userName: 'Mohamed Ali',
          isVerified: true,
          date: 'Sat Jun 20, 1-2024',
          businessName: 'Aqua Candles',
          businessType: 'Home accessories',
          images: [
            'https://images.unsplash.com/photo-1603006905003-be475563bc59?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=987&q=80',
            'https://images.unsplash.com/photo-1599751449128-eb7249c3d6b1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1169&q=80',
          ],
          offerAmount: '10,000 EGP',
          offerPercent: '20% off total project',
          userAvatar: 'https://randomuser.me/api/portraits/men/32.jpg',
          isFavorite: false,
        ),
        const SizedBox(height: 16),
        _buildDealCard(
          userName: 'Ayman Rajaie',
          isVerified: false,
          date: 'Sat Jun 20, 1-2024',
          businessName: 'Cozy Life',
          businessType: 'Home accessories',
          images: [
            'https://images.unsplash.com/photo-1591825729269-caeb344f6df2?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
            'https://images.unsplash.com/photo-1584473457406-6240486418e9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80',
          ],
          offerAmount: '10,000 EGP',
          offerPercent: '20% off total project',
          userAvatar: 'https://randomuser.me/api/portraits/men/45.jpg',
          isFavorite: true,
        ),
      ],
    );
  }

  Widget _buildDealCard({
    required String userName,
    required bool isVerified,
    required String date,
    required String businessName,
    required String businessType,
    required List<String> images,
    required String offerAmount,
    required String offerPercent,
    required String userAvatar,
    required bool isFavorite,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(userAvatar),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 3,
                          backgroundColor: isVerified ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isVerified ? 'Verified' : 'Unverified',
                          style: TextStyle(
                            color: isVerified ? Colors.green : Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isFavorite ? Icons.favorite : Icons.more_vert,
                size: 18,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Business Name:',
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                businessName,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Business Type:',
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                businessType,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Description:',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua, consectetur ipsum dolor sit amet, consectetur.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 11,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Offer Money:',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offerAmount,
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Offer Deal:',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offerPercent,
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: images.map((imageUrl) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}








/*
 /* Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                  const SizedBox(
                    width: 8,
                  ),
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
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  "Business Name : ",
                  style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Aqua-Candels ",
                  style: TextStyle(
                      color: Constant.blackColorDark,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
           const Padding(
            padding:  EdgeInsets.only(left:20),
            child:  Row(
              children: [
                Text(
                  "Business Type : ",
                  style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Home accessories",
                  style: TextStyle(
                      color: Constant.blackColorDark,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              " Description",
              style: TextStyle(
                  color: Constant.mainColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              " Lorem ipsum dolor sit amet, consectetur adipisicing elit,\n sed do eusmod tempor incididunt ut labore et dolore \n magna aliqua. Lorem ipsum dolor sit amet, consectetur \n adipisicing elit, sed doeiusmod tempor incididunt ut \n labore et dolore magna aliquaLorem ipsum dolor sit \n amet, consectetur adipisicing elit. ",
            ),
          ),

          const SizedBox(  height: 8,),

          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Text(
                  "Offer Money : ",
                  style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "10,000 EGP",
                  style: TextStyle(
                      color: Constant.mainColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [

                Text("Offer Deals : ",
                  style: TextStyle(
                      color: Constant.mainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
               
                Text("20% of total project",
                  style: TextStyle(
                      color: Constant.mainColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox( height: 10,),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/photo1.png',
                  width: 190,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/photo2.png',
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'assets/images/photo3.png',
                      width: 150,
                      fit: BoxFit.cover,
                    ),

                  ],
                ),
              ],
            ),
          ),

         
         ],
            ),
          ),*/
*/