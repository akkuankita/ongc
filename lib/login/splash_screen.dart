import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/bottombar/mytab_bar.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/login/login_screen.dart';
import 'package:ongcguest_house/my_sharepref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () {
        // Get.offAll(() => const LoginScreen());
        if (sharedPref.getLogin()) {
          debugPrint(
              "login status ${sharedPref.getLogin()} & token ${sharedPref.getToken()}");
          Get.offAll(() => const MyTabBar());
        } else {
          Get.offAll(() => const LoginScreen());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        decoration: const BoxDecoration(color: kPrimaryColor
            // image: DecorationImage(
            //     image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover),
            ),
        child: Center(
          child: Image.asset("assets/images/logo.jpeg", width: 200.w),
        ),
      ),
    );
  }
}
