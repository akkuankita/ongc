import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

const kPrimaryColor = Color(0xffa41d23);
//const kPrimaryColor = Color(0xff00a65a);
const kPrimarylightColor = Color(0xff55C2ED);
const kborder = Color(0xFFD9D9D9);
const kTextColor = Color(0xFF212121);
const white = Color(0xFFFFFFFF);
const border = Color(0xFF82909B);
const Color red = Color(0xFFdc3545);
const Color green = Color(0xff00a65a);
const Color bgColorPrimary = Color.fromARGB(244, 245, 237, 245);
const Color bgColorSecondary = Color.fromARGB(255, 242, 213, 243);

//-------------------------Custom Text--------------------

Widget customText(String text, double size,
    {Color textColor = kTextColor,
    fontWeight,
    fontFamily,
    int maxLine = 1,
    TextAlign align = TextAlign.left,
    double? height}) {
  return SizedBox(
    child: Text(
      text,
      textAlign: align,
      maxLines: maxLine,
      style: TextStyle(
        color: textColor,
        fontSize: size,
        height: height,
        fontFamily: "OpenSansRegular",
        fontWeight: fontWeight ?? FontWeight.normal,
      ),
    ),
  );
}

//-------------------------input decoration--------------------//
InputDecoration myInputDecoration(
    {required String hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool isLabel = true}) {
  return InputDecoration(
    alignLabelWithHint: true,
    fillColor: white,
    filled: true,
    labelText: hintText,
    labelStyle: TextStyle(
        color: kTextColor.withOpacity(.8),
        fontSize: 14.sp,
        fontFamily: "OpenSansRegular"),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.r),
      borderSide: const BorderSide(
        color: Color(0xFFCCCCCC),
      ),
      gapPadding: 10,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.r),
      borderSide: const BorderSide(color: red),
      gapPadding: 10,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.r),
      borderSide: const BorderSide(color: red),
      gapPadding: 10,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.r),
      borderSide: const BorderSide(color: kPrimaryColor),
      gapPadding: 10,
    ),
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
  );
}

//-------------------------DefaultButton--------------------

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 48.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r), color: kPrimaryColor
          // image: const DecorationImage(
          //     image: AssetImage('assets/images/bg.png'), fit: BoxFit.fill),
          ),
      child: ElevatedButton(
          onPressed: press,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: customText(text, 16.sp,
              textColor: white, fontWeight: FontWeight.w500)),
    );
  }
}

//-----------------show progress------------------

showProgress() {
  Get.dialog(CupertinoActivityIndicator(
    radius: 25.r,
    color: kPrimaryColor,
  ));
}

//------------------hide progress------------------
hideProgress() => Get.back();

//---------------------------show Toast-------------------
showToast(String msg, {Color color = red}) => Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    //  gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: white,
    fontSize: 14.0);
