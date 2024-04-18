import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/bottombar/mytab_bar.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/my_sharepref.dart';
import 'package:ongcguest_house/pages/all_booking_screen.dart';
import 'package:ongcguest_house/pages/employee/employee_list.dart';
import 'package:ongcguest_house/pages/reports/employee_screen.dart';
import 'package:ongcguest_house/pages/reports/payment_screen.dart';
import 'package:ongcguest_house/pages/reports/property_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF222d32),
      child: SafeArea(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: kPrimaryColor),
              child: Column(
                children: [
                  sharedPref.getPhoto().isEmpty
                      ? Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(100.r)),
                          child: const Icon(Icons.person,
                              color: kPrimaryColor, size: 35))
                      : Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(100.r)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              height: 70.h,
                              width: 70.h,
                              imageUrl: sharedPref.getPhoto(),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: kPrimaryColor),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: customText("No Image", 22.sp,
                                    textColor: kPrimaryColor,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(height: 10.h),
                  customText(sharedPref.getName(), 14.sp,
                      textColor: white, fontWeight: FontWeight.w600),
                  SizedBox(height: 2.h),
                  customText(sharedPref.getEmail(), 14.sp, textColor: white),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Get.to(() => const MyTabBar());
              },
              title: customText("Dashboard", 14.sp, textColor: white),
            ),
            Divider(
                thickness: 1.h, color: const Color.fromARGB(43, 239, 239, 239)),

            ListTile(
              onTap: () {
                Get.back();
                Get.to(() => const AllBookingScreen());
              },
              title: customText("All Booking", 14.sp, textColor: white),
            ),
            Divider(
                thickness: 1.h, color: const Color.fromARGB(43, 239, 239, 239)),

            ListTile(
              onTap: () {
                Get.back();
                Get.to(() => const EmployeeList());
              },
              title: customText("Employee list", 14.sp, textColor: white),
            ),
            Divider(
                thickness: 1.h, color: const Color.fromARGB(43, 239, 239, 239)),
            // ListTile(
            //   onTap: () {
            //     Get.to(() => const AmenitiesScreen());

            //   },
            //   title: customText("Amenities", 14.sp, textColor: white),
            // ),
            // Divider(
            //     thickness: 1.h, color: const Color.fromARGB(43, 239, 239, 239)),
            // ListTile(
            //   onTap: () {
            //     Get.to(() => const CompaniesScreen());
            //   },
            //   title: customText("Companies", 14.sp, textColor: white),
            // ),
            // Divider(
            //     thickness: 1.h, color: const Color.fromARGB(43, 239, 239, 239)),
            // ListTile(
            //   onTap: () {
            //     Get.to(() => const CategoriesScreen());
            //   },
            //   title: customText("Categories", 14.sp, textColor: white),
            // ),
            // Divider(
            //     thickness: 1.h, color: const Color.fromARGB(43, 239, 239, 239)),
            // ListTile(
            //   onTap: () {
            //     Get.to(() => const UsersScreen());
            //   },
            //   title: customText("Users", 14.sp, textColor: white),
            // ),
            // Divider(
            //     thickness: 1.h, color: const Color.fromARGB(43, 239, 239, 239)),
            ListTile(
              onTap: () {},
              title: customText("Reports", 14.sp, textColor: white),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Get.back();
                      Get.to(() => const EmployeeScreen(
                            guestId: "",
                            guestname: "",
                          ));
                    },
                    title: customText("Employee Wise", 14.sp, textColor: white),
                  ),
                  Divider(
                      thickness: 1.h,
                      color: const Color.fromARGB(43, 239, 239, 239)),
                  ListTile(
                    onTap: () {
                      Get.back();
                      Get.to(() => const PropertyScreen());
                    },
                    title: customText("Property Wise", 14.sp, textColor: white),
                  ),
                  Divider(
                      thickness: 1.h,
                      color: const Color.fromARGB(43, 239, 239, 239)),
                  ListTile(
                    onTap: () {
                      Get.back();
                      Get.to(() => const PaymentScreen());
                    },
                    title: customText("Payments", 14.sp, textColor: white),
                  ),
                ],
              ),
            ),

            Divider(
                thickness: 1.h, color: const Color.fromARGB(43, 239, 239, 239)),
          ],
        ),
      ),
    );
  }
}
