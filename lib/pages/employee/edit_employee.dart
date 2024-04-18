import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/employee/companylist_modal.dart';
import 'package:ongcguest_house/network/modal/employee/countrylist_modal.dart';
import 'package:ongcguest_house/network/modal/employee/employeedetail_modal.dart';
import 'package:ongcguest_house/network/modal/employee/statelist_modal.dart';
import 'package:ongcguest_house/pages/employee/employee_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class EditEmployee extends StatefulWidget {
  final EmployeeDetailData? empDetail;
  const EditEmployee({super.key, required this.empDetail});

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  RxBool isLoading = true.obs;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _contact = TextEditingController();
  final _altcontact = TextEditingController();
  final _empid = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _id = TextEditingController();
  final _docone = TextEditingController();
  final _doctwo = TextEditingController();
  final _docthree = TextEditingController();
  String radioButtonItem = '';
  int radioButtonid = 0;

// ----profile pic---
  File? profileFile;
  String? _profilePath;
  String? profilepathforapi = '';

// ----------------one--------------
  File? imgPathone;
  String? pathoneBase64 = '';
// -------------two---------------
  File? imgPathtwo;
  String? pathtwoBase64 = '';
// ---------------three---------
  File? imgPaththree;
  String? paththreeBase64 = '';

  @override
  void initState() {
    super.initState();
    _id.text = widget.empDetail!.id.toString();
    companyid = widget.empDetail!.userCompanyId.toString();
    _name.text = widget.empDetail!.userName.toString();
    _email.text = widget.empDetail!.userEmail.toString();
    _contact.text = widget.empDetail!.userMobile.toString();
    _altcontact.text = widget.empDetail!.altContact.toString();
    _empid.text = widget.empDetail!.employeeId.toString();
    _address.text = widget.empDetail!.address.toString();
    _city.text = widget.empDetail!.city.toString();
    countryid = widget.empDetail!.countryId.toString();
    _profilePath = widget.empDetail!.userPhoto;
    if (_profilePath != '') {
      networkprofileToBase64(_profilePath!).then((value) {
        profilepathforapi = value!;
        return value;
      });
    }
    if (widget.empDetail!.countryId == 0) {
      countryid = null;
    }
    stateid = widget.empDetail!.stateId.toString();
    if (widget.empDetail!.stateId != 0) {
      setState(() {
        _getcontrylist();
      });
    }
    radioButtonid = widget.empDetail!.foodComplementary!;
    if (radioButtonid == 0) {
      radioButtonItem == "Personal";
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getcompanylist();
      _getcontrylist();
    });
  }

  // ------ Company list api ---
  var companyData = <CompanyListsData>[].obs;
  String? companyid;
  _getcompanylist() async {
    isLoading.value = true;
    var data = await api.companyListsApiCall();
    isLoading.value = false;
    if (data != null) {
      companyData.value = data;
    }
  }

  // ------ Contry list api ---
  var countryData = <CountryListData>[].obs;
  String? countryid;
  _getcontrylist() async {
    isLoading.value = true;
    var data = await api.countryApiCall();
    isLoading.value = false;
    if (data != null) {
      countryData.value = data;
    }
  }

  // ------ Contry list api ---
  var stateData = <StateListData>[].obs;
  String? stateid;
  _getstatelist() async {
    isLoading.value = true;
    var data = await api.stateApiCall(countryid.toString());
    isLoading.value = false;
    if (data != null) {
      stateData.value = data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: customText("Edit Employee", 14.sp, textColor: white),
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
                  SizedBox(height: 10.h),
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
                            child: profileFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: Image.file(profileFile!,
                                        width: 50.w,
                                        height: 50.w,
                                        fit: BoxFit.cover),
                                  )
                                : _profilePath != ''
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                        child: CachedNetworkImage(
                                            imageUrl: _profilePath!,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress,
                                                    color: kPrimaryColor),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: SvgPicture.asset(
                                                      "assets/icon/user.svg",
                                                      width: 100.w,
                                                      height: 100.w,
                                                      fit: BoxFit.cover,
                                                      color: kPrimaryColor),
                                                ),
                                            fit: BoxFit.cover))
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: SvgPicture.asset(
                                              "assets/icon/user.svg",
                                              fit: BoxFit.fill,
                                              color: kPrimaryColor),
                                        ),
                                      ),
                          ),

                          // Container(
                          //   width: 100.w,
                          //   height: 100.w,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(100.r),
                          //     border: Border.all(
                          //         width: 1, color: const Color(0xFFD9D9D9)),
                          //   ),
                          //   child: profileFile != null
                          //       ? ClipRRect(
                          //           borderRadius: BorderRadius.circular(50.r),
                          //           child: Image.file(profileFile!,
                          //               width: 50.w,
                          //               height: 50.w,
                          //               fit: BoxFit.cover),
                          //         )
                          //       : _profilePath != ''
                          //           ? ClipRRect(
                          //               borderRadius: BorderRadius.circular(50.r),
                          //               child: CachedNetworkImage(
                          //                   imageUrl: _profilePath!,
                          //                   progressIndicatorBuilder: (context,
                          //                           url, downloadProgress) =>
                          //                       CircularProgressIndicator(
                          //                           value:
                          //                               downloadProgress.progress,
                          //                           color: kPrimaryColor),
                          //                   errorWidget: (context, url, error) =>
                          //                       Padding(
                          //                         padding:
                          //                             const EdgeInsets.all(18.0),
                          //                         child: SvgPicture.asset(
                          //                             "assets/icon/user.svg",
                          //                             width: 100.w,
                          //                             height: 100.w,
                          //                             fit: BoxFit.cover,
                          //                             color: kPrimaryColor),
                          //                       ),
                          //                   fit: BoxFit.cover))
                          //           : ClipRRect(
                          //               borderRadius: BorderRadius.circular(50.r),
                          //               child: Padding(
                          //                 padding: const EdgeInsets.all(18.0),
                          //                 child: SvgPicture.asset(
                          //                     "assets/icon/user.svg",
                          //                     fit: BoxFit.fill,
                          //                     color: kPrimaryColor),
                          //               ),
                          //             ),
                          // ),

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
                                        leading: const Icon(
                                            Icons.image_outlined,
                                            color: kPrimaryColor),
                                        title: customText("Gallery", 14.sp),
                                        onTap: () {
                                          _chooseProfile(type: 'gallery');
                                          Get.back();
                                        },
                                      ),
                                      Divider(
                                          color: kTextColor.withOpacity(.5),
                                          height: 1),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: kPrimaryColor),
                                        title: customText("Camera", 14.sp),
                                        onTap: () {
                                          _chooseProfile(type: 'camera');
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
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 4.0),
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
                  SizedBox(height: 30.h),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return 'Please Company Name';
                        }
                        return null;
                      },
                      decoration: myInputDecoration(hintText: "Company Name"),
                      items: companyData
                          .map((value) => DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Text(" ${value.name}")))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          companyid = value!.toString();
                          // print(companyid);
                        });
                      },
                      value: companyid,
                    );
                  }),
                  SizedBox(height: 20.h),
                  // TextFormField(
                  //   controller: _id,
                  //   decoration: myInputDecoration(hintText: "ID"),
                  // ),
                  // SizedBox(height: 20.h),
                  TextFormField(
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Please Enter Name';
                      }
                      return null;
                    },
                    controller: _name,
                    decoration: myInputDecoration(hintText: "Name"),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                    controller: _email,
                    decoration: myInputDecoration(hintText: "Email"),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Please enter phone number';
                      } else if (val.length < 10) {
                        return 'Phone number should be 10 digits';
                      }
                      return null;
                    },
                    controller: _contact,
                    decoration: myInputDecoration(hintText: "Contact Number"),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _altcontact,
                    decoration:
                        myInputDecoration(hintText: "Alt. Contact number"),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _empid,
                    decoration: myInputDecoration(hintText: "Employee ID"),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _address,
                    decoration: myInputDecoration(hintText: "Address"),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _city,
                    decoration: myInputDecoration(hintText: "City"),
                    onTap: () async {},
                  ),
                  SizedBox(height: 20.h),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      decoration: myInputDecoration(hintText: "Select Country"),
                      items: countryData
                          .map((value) => DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Text(" ${value.name}")))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          countryid = value!.toString();
                          //   print(countryid);
                          stateid = null;
                          stateData.clear();
                        });
                        _getstatelist();
                        setState(() {});
                      },
                      value: countryid,
                    );
                  }),
                  SizedBox(height: 20.h),
                  Obx(() {
                    return DropdownButtonFormField<String>(
                      decoration: myInputDecoration(hintText: "Select State"),
                      items: stateData
                          .map((value) => DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Text(" ${value.name}")))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          stateid = value!.toString();
                          //  print(stateid);
                        });
                      },
                      value: stateid,
                    );
                  }),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Food',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 0,
                              groupValue: radioButtonid,
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = 'Personal';
                                  radioButtonid = 0;
                                });
                              },
                            ),
                            const Text(
                              'Personal',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: radioButtonid,
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = 'Official';
                                  radioButtonid = 1;
                                });
                              },
                            ),
                            const Text(
                              'Official',
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  customText("Documentation", 14.sp,
                      fontWeight: FontWeight.w600),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _docone,
                          decoration:
                              myInputDecoration(hintText: "Document Name"),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                  width: 1, color: const Color(0xFFCCCCCC)),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 40.w,
                                height: 33.w,
                                child: Stack(
                                  children: [
                                    imgPathone != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                            child: Image.file(imgPathone!,
                                                fit: BoxFit.fill),
                                          )
                                        : Icon(Icons.image,
                                            size: 30,
                                            color: kTextColor.withOpacity(.5)),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            imgPathone = null;
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
                              ),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Get.bottomSheet(ColoredBox(
                                      color: white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                                Icons.image_outlined,
                                                color: kPrimaryColor),
                                            title: customText("Gallery", 14.sp),
                                            onTap: () {
                                              _chooseone(ImageSource.gallery);
                                              Get.back();
                                            },
                                          ),
                                          Divider(
                                              color: kTextColor.withOpacity(.5),
                                              height: 1),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.camera_alt_outlined,
                                                color: kPrimaryColor),
                                            title: customText("Camera", 14.sp),
                                            onTap: () {
                                              _chooseone(ImageSource.camera);
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      ),
                                    ));
                                  },
                                  icon: const Icon(Icons.attach_file,
                                      size: 20, color: kPrimaryColor)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _doctwo,
                          decoration:
                              myInputDecoration(hintText: "Document Name"),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                  width: 1, color: const Color(0xFFCCCCCC)),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 40.w,
                                height: 33.w,
                                child: Stack(
                                  children: [
                                    imgPathtwo != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                            child: Image.file(imgPathtwo!,
                                                fit: BoxFit.fill),
                                          )
                                        : Icon(Icons.image,
                                            size: 30,
                                            color: kTextColor.withOpacity(.5)),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            imgPathtwo = null;
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
                              ),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Get.bottomSheet(ColoredBox(
                                      color: white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                                Icons.image_outlined,
                                                color: kPrimaryColor),
                                            title: customText("Gallery", 14.sp),
                                            onTap: () {
                                              _choosetwo(ImageSource.gallery);
                                              Get.back();
                                            },
                                          ),
                                          Divider(
                                              color: kTextColor.withOpacity(.5),
                                              height: 1),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.camera_alt_outlined,
                                                color: kPrimaryColor),
                                            title: customText("Camera", 14.sp),
                                            onTap: () {
                                              _choosetwo(ImageSource.camera);
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      ),
                                    ));
                                  },
                                  icon: const Icon(Icons.attach_file,
                                      size: 20, color: kPrimaryColor)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _docthree,
                          decoration:
                              myInputDecoration(hintText: "Document Name"),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                  width: 1, color: const Color(0xFFCCCCCC)),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 40.w,
                                height: 33.w,
                                child: Stack(
                                  children: [
                                    imgPaththree != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4.r),
                                            child: Image.file(imgPaththree!,
                                                fit: BoxFit.fill),
                                          )
                                        : Icon(Icons.image,
                                            size: 30,
                                            color: kTextColor.withOpacity(.5)),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            imgPaththree = null;
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
                              ),
                              IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    Get.bottomSheet(ColoredBox(
                                      color: white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(
                                                Icons.image_outlined,
                                                color: kPrimaryColor),
                                            title: customText("Gallery", 14.sp),
                                            onTap: () {
                                              _choosethree(ImageSource.gallery);
                                              Get.back();
                                            },
                                          ),
                                          Divider(
                                              color: kTextColor.withOpacity(.5),
                                              height: 1),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.camera_alt_outlined,
                                                color: kPrimaryColor),
                                            title: customText("Camera", 14.sp),
                                            onTap: () {
                                              _choosethree(ImageSource.camera);
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      ),
                                    ));
                                  },
                                  icon: const Icon(Icons.attach_file,
                                      size: 20, color: kPrimaryColor)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  DefaultButton(
                    text: "Save",
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        _editemp(
                          _profilePath.toString(),
                          _id.text,
                          companyid.toString(),
                          _name.text,
                          _email.text,
                          _contact.text,
                          _altcontact.text,
                          _empid.text,
                          _address.text,
                          _city.text,
                          countryid.toString(),
                          stateid.toString(),
                          radioButtonid.toString(),
                          _docone.text,
                          pathoneBase64!,
                          _doctwo.text,
                          pathtwoBase64!,
                          _docthree.text,
                          paththreeBase64!,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> networkprofileToBase64(String profilePath) async {
    http.Response response = await http.get(Uri.parse(profilePath));
    final bytes = response.bodyBytes;
    return base64Encode(bytes);
  }

  void _chooseProfile({required String type}) async {
    final picker = ImagePicker();
    final selectedImage = await picker.pickImage(
      source: type == 'camera' ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );
    if (selectedImage != null) {
      File rotatedImg =
          await FlutterExifRotation.rotateImage(path: selectedImage.path);
      setState(() {
        profileFile = File(rotatedImg.path);
        _profilePath = rotatedImg.path;
        final bytes = io.File(rotatedImg.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        _profilePath = img64;
      });
      profilepathforapi = _profilePath;
    }
  }

  // ----------OneDoc-----------
  void _chooseone(ImageSource source) async {
    var result = await _picker.pickImage(source: source);
    if (result != null) {
      imgPathone = File(result.path);
      setState(() {});
    }
    Uint8List? imagebytes = await imgPathone?.readAsBytes();
    String base64string = base64.encode(imagebytes!);
    pathoneBase64 = base64string;
  }

  // ----------twoDoc-----------
  void _choosetwo(ImageSource source) async {
    var result = await _picker.pickImage(source: source);
    if (result != null) {
      imgPathtwo = File(result.path);
      setState(() {});
    }
    Uint8List? imagebytes = await imgPathtwo?.readAsBytes();
    String base64string = base64.encode(imagebytes!);
    pathtwoBase64 = base64string;
  }

  // ----------threeDoc-----------
  void _choosethree(ImageSource source) async {
    var result = await _picker.pickImage(source: source);
    if (result != null) {
      imgPaththree = File(result.path);
      setState(() {});
    }
    Uint8List? imagebytes = await imgPaththree?.readAsBytes();
    String base64string = base64.encode(imagebytes!);
    paththreeBase64 = base64string;
  }

  void _editemp(
    String profilePath,
    String id,
    String companyid,
    String name,
    String email,
    String contact,
    String altcontact,
    String empid,
    String address,
    String city,
    String countryid,
    String stateid,
    String radioButtonid,
    String docone,
    String onebase,
    String doctwo,
    String twobase,
    String docthree,
    String threebase,
  ) async {
    var result = await api.editempApiCall(
      profilePath: profilepathforapi,
      id: id,
      companyid: companyid,
      name: name,
      email: email,
      contact: contact,
      altcontact: altcontact,
      empid: empid,
      address: address,
      city: city,
      countryid: countryid,
      stateid: stateid,
      radioButtonid: radioButtonid,
      docone: docone,
      onebase: onebase,
      doctwo: doctwo,
      twobase: twobase,
      docthree: docthree,
      threebase: threebase,
    );
    if (result != null) {
      // print("Edit");
      Get.to(() => const EmployeeList());
      setState(() {});
    }
  }
}
