
import 'package:flutter/material.dart';
import 'package:innovahub_app/home/cart_Tap.dart';
import 'package:innovahub_app/home/favourite_Tap.dart';
import 'package:innovahub_app/home/home_Tap_User.dart';
import 'package:innovahub_app/home/search_Tap.dart';
import 'package:innovahub_app/profiles/profile_tap_User.dart';

abstract class UserHomeLayout {
  static List<Widget> screens = [
    const HomeScreenUser(),
     FavouriteTab(),
    const CartTap(),
    const SearchTap(),
    const ProfileUser(),
  ];
  static List<BottomNavigationBarItem> bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.home_filled,
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.favorite_border_outlined,
      ),
      label: "Wishlist",
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.shopping_cart_outlined,
      ),
      label: "Cart",
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.search_outlined,
      ),
      label: "Search",
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.person_outline,
      ),
      label: "Profile",
    ),
  ];
}
