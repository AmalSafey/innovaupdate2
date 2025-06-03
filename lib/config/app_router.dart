import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innovahub_app/Auth/Auth_Cubit/Auth_cubit.dart';
import 'package:innovahub_app/Auth/register/register_screen.dart';
import 'package:innovahub_app/Models/product_response.dart';
import 'package:innovahub_app/Models/products/product_model.dart';
import 'package:innovahub_app/Products/payment_page.dart';
import 'package:innovahub_app/home/Deals/adding_deal_owner.dart';
import 'package:innovahub_app/home/Deals/owner_product.dart';
import 'package:innovahub_app/home/add_Tap_owner.dart';
import 'package:innovahub_app/home/controller/owner_home_layout/owner_home_layout_cubit.dart';
import 'package:innovahub_app/home/controller/user_home_layout_cubit/user_home_layout_cubit.dart';
import 'package:innovahub_app/home/home_Tap_Categories.dart';
import 'package:innovahub_app/home/home_Tap_Investor.dart';
import 'package:innovahub_app/home/home_Tap_User.dart';
import 'package:innovahub_app/home/home_Tap_owner.dart';
import 'package:innovahub_app/home/user_home_screen.dart';
import 'package:innovahub_app/home/register_page.dart';
import 'package:innovahub_app/profiles/Widgets/myorder.dart';
import 'package:innovahub_app/profiles/privacy_owner_investor.dart';
import 'package:innovahub_app/profiles/privacy_user.dart';
import 'package:innovahub_app/profiles/profile_tap_Investor.dart';
import 'package:innovahub_app/profiles/profile_tap_User.dart';
import 'package:innovahub_app/splash_screen.dart';
import 'package:innovahub_app/Products/buy_page.dart';
import 'package:innovahub_app/Products/cart_page.dart';
import 'package:innovahub_app/Products/checkout_address.dart';
import 'package:innovahub_app/Products/product_page.dart';
import 'package:innovahub_app/Auth/login/forget_password.dart';
import 'package:innovahub_app/Auth/login/login_screen.dart';
import 'package:innovahub_app/Auth/login/reset_password.dart';

abstract class AppRouter {
  static const String initRoute = RegisterScreen.routeName;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static Map<String, Widget Function(BuildContext)> routes() => {
        TrainingPage.routeName: (_) => TrainingPage(),
        SplashScreen.routeName: (_) => const SplashScreen(),
        RegisterScreen.routeName: (_) => BlocProvider(
              create: (context) => AuthCubit(),
              child: const RegisterScreen(),
            ),
        LoginScreen.routname: (_) => BlocProvider(
              create: (context) => AuthCubit(),
              child: const LoginScreen(),
            ),
        ForgetPasswordScreen.routname: (contect) => ForgetPasswordScreen(),
        resetpassword.routname: (_) => const resetpassword(),
        UserHomeScreen.routeName: (_) => BlocProvider(
              create: (context) => UserHomeLayoutCubit(),
              child: const UserHomeScreen(),
            ),
        HomeScreenOwner.routeName: (_) => BlocProvider(
              create: (context) => OwnerHomeLayoutCubit(),
              child: const HomeScreenOwner(),
            ),
        // AddingDealOwner.routeName : (_) => AddingDealOwner(),
        HomeScreenUser.routeName: (_) => HomeScreenUser(),
        // PrivacySecurityPage.routeName:(_) => PrivacySecurityPage(),
        HomeScreenInvestor.routeName: (_) => const HomeScreenInvestor(),
        HomeScreenCategories.routeName: (_) => const HomeScreenCategories(),
        ProfileInvestor.routeName: (_) => const ProfileInvestor(),
        ProfileUser.routeName: (_) => const ProfileUser(),
        PrivacyUser.routeName: (_) => const PrivacyUser(),
        PrivacyOwnerInvestor.routeName: (_) => const PrivacyOwnerInvestor(),
        PublishDealScreen.routeName: (_) => const PublishDealScreen(),
        ProductPage.routeName: (_) => const ProductPage(),
        //CartTap.routeName : (_) => CartTap(),
        CartPage.routeName: (_) => const CartPage(),
        //BuyPage.routeName: (_) => const BuyPage(),
        CheckoutAddress.routeName: (_) => const CheckoutAddress(),
        OwnerPublish.routeName: (_) => const OwnerPublish(),
        PaymentPage.routeName: (_) => const PaymentPage(),
        ReviewScreen.routeName:(_) => ReviewScreen(),
      };
}
