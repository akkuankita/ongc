import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/bottombar/mytab_bar.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isShowPassword = false;
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover),
        ),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child:
                        Image.asset("assets/images/logo.jpeg", width: 150.w)),
                SizedBox(height: 40.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: white, borderRadius: BorderRadius.circular(12.r)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // customText("Login", 16.sp, fontWeight: FontWeight.w500),
                      // SizedBox(height: 20.h),

                      TextFormField(
                        controller: _email,
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Please Enter Email ID';
                          } else if (!val.isEmail) {
                            return 'Please enter correct email id';
                          }
                          return null;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9@.]'))
                        ],
                        keyboardType: TextInputType.emailAddress,
                        decoration: myInputDecoration(hintText: "Email Id"),
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: _password,
                        obscureText: !_isShowPassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) {
                          if (val!.trim().isEmpty) {
                            return 'Please enter your Password';
                          } else if (val.length < 5) {
                            return 'Password range should be 5-20 character';
                          } else {
                            return null;
                          }
                        },
                        decoration: myInputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isShowPassword = !_isShowPassword;
                              });
                            },
                            icon: Icon(
                              _isShowPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFFA4A4A4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      DefaultButton(
                          text: "Login",
                          press: () {
                            // Get.offAll(()=> const MyTabBar());
                            if (_formKey.currentState!.validate()) {
                              _login(
                                _email.text,
                                _password.text,
                              );
                            }
                          }),
                      SizedBox(height: 20.h),
                      customText("I forgot my password", 14.sp)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(String email, String password) async {
    var result = await api.loginApiCall(email: email, password: password);
    if (result == true) {
      Get.offAll(() => const MyTabBar());
    }
    return null;
  }
}
