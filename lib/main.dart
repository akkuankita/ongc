import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/login/splash_screen.dart';
import 'package:ongcguest_house/my_sharepref.dart';

import 'network/api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPref.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!),
            title: "ONGC Guest House",
            debugShowCheckedModeBanner: false,
            theme: theme(),
            home: const SplashScreen(),
            initialBinding: BindingsBuilder(() {
              Get.put(Api());
            }),
          );
        });
  }
}

ThemeData theme() {
  return ThemeData(fontFamily: "Rajdhani", appBarTheme: appBarTheme());
}

appBarTheme() {
  return const AppBarTheme(
    backgroundColor: kPrimaryColor,
    elevation: 2,
    iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
  );
}
