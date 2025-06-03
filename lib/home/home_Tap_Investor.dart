
import 'package:flutter/material.dart';
import 'package:innovahub_app/core/Constants/Colors_Constant.dart';
import 'package:innovahub_app/home/Deals/deal_tap_investor.dart';
import 'package:innovahub_app/home/home_Investor.dart';
import 'package:innovahub_app/home/search_Tap.dart';
import 'package:innovahub_app/profiles/profile_tap_Investor.dart';

class HomeScreenInvestor extends StatefulWidget {
  const HomeScreenInvestor({super.key});

  static const String routeName = 'home_investor';       // routeName:
  @override
  State<HomeScreenInvestor> createState() => _HomeScreenInvestorState();
}

class _HomeScreenInvestorState extends State<HomeScreenInvestor> {

    int select = 0;

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constant.whiteColor,
        elevation: 0,
        title: const Text(
          'Innova',
          style: TextStyle(
              color: Constant.blackColorDark,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundImage:
                  AssetImage('assets/images/investor1.png'), // ضع الصورة هنا
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.trending_up,
              ),
              label: "Deals",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search_outlined,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
              ),
              label: "Profile",
            ),
          ],
          currentIndex: select,
          onTap: (index) {
            select = index;
            setState(() {});
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),

      body: tabsInvestor[select],

    );
  }


  List<Widget> tabsInvestor = [
    
     const HomeInvestor(),
     const DealInvestor(),
     const SearchTap(),
     const ProfileInvestor(),

  ];
}




