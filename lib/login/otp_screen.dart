import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 
import 'package:ongcguest_house/constants.dart';
 
 
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Duration duration = const Duration();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: customText("OTP", 16.sp, textColor: white),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            customText("Verify Contact Number", 20.sp,
                fontWeight: FontWeight.w800),
            SizedBox(height: 22.h),
            customText("Verification code sent to your contact", 16.sp),
            SizedBox(height: 40.h),
            PinInputTextField(
              pinLength: 4,
              autoFocus: true,
              onChanged: (value) {},
              decoration: BoxLooseDecoration(
                textStyle: const TextStyle(fontSize: 25, color: kTextColor),
                strokeWidth: 2,
                gapSpace: 25,
                strokeColorBuilder: const FixedColorBuilder(
                  Color(0xFFE7EBEE),
                ),
              ),
            ),
            SizedBox(height: 45.h),
            DefaultButton(
                text: "Verify & Proceed",
                press: () {
                
                }),
            SizedBox(height: 45.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customText('Didn’t get the code ? ', 14.sp,
                    fontWeight: FontWeight.bold, textColor: Colors.grey),
                InkWell(
                  onTap: () {},
                  child: customText("Resend Now", 14.sp,
                      textColor: kTextColor, fontWeight: FontWeight.w700),
                )
              ],
            ),
            SizedBox(height: 30.h),
          ],
        ),
      )),
    );
  }

 
}
