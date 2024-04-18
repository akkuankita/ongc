import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: customText("Profile", 14.sp, textColor: white),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: SizedBox(
                  width: 100.w,
                  height: 100.w,
                  child: Stack(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(
                              width: 1, color: const Color(0xFFD9D9D9)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SvgPicture.asset(
                            // ignore: deprecated_member_use
                            "assets/icon/user.svg",
                            // ignore: deprecated_member_use
                            color: kPrimaryColor.withOpacity(.6),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            Get.bottomSheet(ColoredBox(
                              color: white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.image_outlined,
                                        color: kPrimaryColor),
                                    title: customText("Gallery", 14.sp),
                                    onTap: () {
                                      Get.back();
                                    },
                                  ),
                                  Divider(
                                      color: kTextColor.withOpacity(.5),
                                      height: 1),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt_outlined,
                                        color: kPrimaryColor),
                                    title: customText("Camera", 14.sp),
                                    onTap: () {
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            ));
                          },
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4.0),
                              ],
                              color: const Color(0xFFF61574),
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            child: const Icon(Icons.camera_alt_outlined,
                                size: 16, color: white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                decoration: myInputDecoration(hintText: "Name"),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: myInputDecoration(hintText: "Email"),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                validator: (val) {
                  if (val!.trim().isEmpty) {
                    return 'Please enter Contact No';
                  }
                  return null;
                },
                decoration: myInputDecoration(hintText: "Contact No"),
              ),
              SizedBox(height: 20.h),
               customText("Social Links", 14.sp, fontWeight: FontWeight.w500),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: myInputDecoration(hintText: "Facebook"),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: myInputDecoration(hintText: "Google Plus"),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: myInputDecoration(hintText: "Twitter"),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: myInputDecoration(hintText: "Linkedin"),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: myInputDecoration(hintText: "Youtube"),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: myInputDecoration(hintText: "Instagram"),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
