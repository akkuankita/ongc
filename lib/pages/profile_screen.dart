import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';

import 'package:ongcguest_house/pages/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
 RxBool isLoading = true.obs;
// var profilelist = <ProfileData>().obs;

//  void _getprofileData() async {
//     isLoading.value = true;
//     var result = await api.fetchprofile();
//     isLoading.value = false;
//     if (result != null) {
//       profilelist.value = result;
//     }
//   }

@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // _getprofileData();
     
    });
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: customText("Profile", 14.sp, textColor: white),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const EditProfile());
              },
              icon: const Icon(Icons.edit))
        ],
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
                child: Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    border:
                        Border.all(width: 1, color: const Color(0xFFD9D9D9)),
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
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: myInputDecoration(hintText: "Name"),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: myInputDecoration(hintText: "Email"),
              ),
              SizedBox(height: 20.h),
              TextFormField(
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
