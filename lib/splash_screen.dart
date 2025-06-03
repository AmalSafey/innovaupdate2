
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:innovahub_app/Auth/register/register_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

    static const String routeName = 'splash_screen';      // routeName of this screen:

  @override
  Widget build(BuildContext context) {
    return Scaffold(

       body: AnimatedSplashScreen(
        splashIconSize: double.infinity,
          splashTransition: SplashTransition.sizeTransition,
          animationDuration: const Duration(seconds: 2),        // Duration of Splash screen:
       
           splash:  Image.asset('assets/images/splash_screen2.jpg',

           fit: BoxFit.cover             // To fit the image:             
       
           ), 
       
            nextScreen: const RegisterScreen(),

          ),

         );
  }

}





