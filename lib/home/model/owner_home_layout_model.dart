import 'package:flutter/material.dart';
import 'package:innovahub_app/home/Deals/deal_tap_owner.dart';
import 'package:innovahub_app/home/add_Tap_owner.dart';
import 'package:innovahub_app/home/home_owner.dart';
import 'package:innovahub_app/profiles/profile_tap_owner.dart';

abstract class OwnerHomeLayoutModel {
   static List<Widget> screens = [
    
    const HomeOwner(),
    const PublishDealScreen(),
    const DealOwner(),
    const ProfileOwner(),

  ];

  static List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_filled,
      ),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.add,
      ),
      label: "Add",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.trending_up,
      ),
      label: "Deals",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.person_outline,
      ),
      label: "Profile",
    ),
  ];
}
