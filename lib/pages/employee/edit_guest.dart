import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ongcguest_house/constants.dart';
 

class EditGuest extends StatefulWidget {
  const EditGuest({super.key});

  @override
  State<EditGuest> createState() => _EditGuestState();
}

class _EditGuestState extends State<EditGuest> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _address = TextEditingController();
  final _checkIndate = TextEditingController();
  final _checkOutdate = TextEditingController();
  final _room = TextEditingController();
  final _ifanyroom = TextEditingController();
  final _idprrofnumber = TextEditingController();
  final _purpose = TextEditingController();
  final _guesthouse = TextEditingController();
  final _rent = TextEditingController();
  final _bill = TextEditingController();
  final _remark = TextEditingController();
  File? imgId;
  String? imageBaseID64 = '';
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText("Edit New Guest", 14.sp, textColor: white),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _fullName,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Full Name';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "Guest Name"),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _address,
                  maxLines: 2,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Address';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "Address"),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  readOnly: true,
                  controller: _checkIndate,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Check in Date';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "Check in Date"),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100));
                    if (pickedDate != null) {
                      String datetime1 =
                          DateFormat("dd-MMMM-yyyy").format(pickedDate);
                      _checkIndate.text = datetime1;
                    } else {}
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  readOnly: true,
                  controller: _checkOutdate,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Check Out Date';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "Check Out Date"),
                  onTap: () async {
                    DateTime? checkoutDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100));
                    if (checkoutDate != null) {
                      String datetime =
                          DateFormat("dd-MMMM-yyyy").format(checkoutDate);
                      _checkOutdate.text = datetime;
                    } else {}
                  },
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _room,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Room Number';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "No. of room"),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _ifanyroom,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Room Number (If any)';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "Room No (If any)"),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _idprrofnumber,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Id Proof No';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "Id Proof No"),
                ),
                SizedBox(height: 20.h),
                customText("ID Card", 14.sp, textColor: kTextColor),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      color: white,
                      border:
                          Border.all(width: 1, color: const Color(0xFFCCCCCC)),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      imgId != null
                          ? SizedBox(
                              width: 80.w,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(imgId!,
                                        height: 70.w,
                                        width: 70.w,
                                        fit: BoxFit.fill),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          imgId = null;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(50.r)),
                                        child: const Icon(Icons.close,
                                            color: white, size: 20),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(Icons.image,
                                  size: 50, color: kTextColor.withOpacity(.5)),
                            ),
                      IconButton(
                          onPressed: () {
                            Get.bottomSheet(ColoredBox(
                              color: white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: kPrimaryColor),
                                    title: customText("Camera", 14.sp),
                                    onTap: () {
                                      _chooseID(ImageSource.camera);
                                      Get.back();
                                    },
                                  ),
                                  Divider(
                                      color: kTextColor.withOpacity(.5),
                                      height: 1),
                                  ListTile(
                                    leading: const Icon(Icons.image_outlined,
                                        color: kPrimaryColor),
                                    title: customText("Gallery", 14.sp),
                                    onTap: () {
                                      _chooseID(ImageSource.gallery);
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            ));
                          },
                          icon: const Icon(Icons.attach_file,
                              color: kPrimaryColor))
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _purpose,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Purpose of visit';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "Purpose of visit"),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _guesthouse,
                  decoration:
                      myInputDecoration(hintText: "Selection of guest house"),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _rent,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Collection of room rent';
                    }
                    return null;
                  },
                  decoration:
                      myInputDecoration(hintText: "Collection of room rent"),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _bill,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Food bill amount';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "Food bill amount"),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _remark,
                  validator: (val) {
                    if (val!.trim().isEmpty) {
                      return 'Please Enter Remark';
                    }
                    return null;
                  },
                  decoration: myInputDecoration(hintText: "Remark"),
                ),
                SizedBox(height: 20.h),
                DefaultButton(
                    text: "Login",
                    press: () {
                      if (_formKey.currentState!.validate()) {}
                    })
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _chooseID(ImageSource source) async {
    var result = await _picker.pickImage(source: source);
    if (result != null) {
      imgId = File(result.path);
      setState(() {
        // idvereditat = true;
      });
    }
    Uint8List? imagebytes = await imgId?.readAsBytes();
    String base64string = base64.encode(imagebytes!);
    imageBaseID64 = base64string;
  }
}
