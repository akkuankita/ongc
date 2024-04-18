import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/available_rooms_modal.dart';
import 'package:ongcguest_house/network/modal/book_detail_modal.dart';
import 'package:ongcguest_house/network/modal/property_list_modal.dart';
import 'package:ongcguest_house/pages/booking_detail.dart';

class EditBooking extends StatefulWidget {
  final BookDetailData? userId;

  const EditBooking({super.key, this.userId});

  @override
  State<EditBooking> createState() => _EditBookingState();
}

class _EditBookingState extends State<EditBooking> {
  RxBool isLoading = true.obs;
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _checkindate = TextEditingController();
  final _checkintime = TextEditingController();
  final _checkoutdate = TextEditingController();
  final _checkouttime = TextEditingController();
  // final _guestname = TextEditingController();
  final _bookingguest = TextEditingController();
  final _purpose = TextEditingController();
  final _adult = TextEditingController();
  final _child = TextEditingController();
  final _infant = TextEditingController();
  final _bookId = TextEditingController();
  final _userId = TextEditingController();
  final _docone = TextEditingController();
  final _doctwo = TextEditingController();
  final _docthree = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var timein;
  var timeout;
  bool hide = false;
  String radioButtonItem = 'Self', ids = '';
  int radioButtonid = 0;

  final ImagePicker _picker = ImagePicker();
// ----------------one--------------
  File? imgPathone;
  String? pathoneBase64 = '';
// -------------two---------------
  File? imgPathtwo;
  String? pathtwoBase64 = '';
// ---------------three---------
  File? imgPaththree;
  String? paththreeBase64 = '';
  int _isSelectedRoomId = 0;

  @override
  void initState() {
    super.initState();

    _bookId.text = widget.userId!.bookingId.toString();
    _userId.text = widget.userId!.userId.toString();
    _username.text = widget.userId!.userName.toString();
    propertyid = widget.userId!.propertyId.toString();
    statusid = widget.userId!.statusId!.toString();
    ids = widget.userId!.roomId.toString();
    _checkindate.text = widget.userId!.checkinDate.toString();
    _checkintime.text = widget.userId!.checkinTime.toString();
    _checkoutdate.text = widget.userId!.checkoutDate.toString();
    _checkouttime.text = widget.userId!.checkoutTime!;
    radioButtonItem = widget.userId!.bookingFor!;
    radioButtonid = widget.userId!.bookingForId!;
    // if (radioButtonItem == "Others") {
    //   radioButtonid = 1;
    // }
    // "booking_for_id": 0,
    //       "booking_for": "Self",
    _adult.text = widget.userId!.adult.toString();
    _child.text = widget.userId!.child.toString();
    _infant.text = widget.userId!.infant.toString();
    _purpose.text = widget.userId!.visitPurpose!;
    _bookingguest.text = widget.userId!.bookingForGuest!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getpropertyData();
      _getDetailData();
    });
  }

  var propertyData = <PropertyData>[].obs;
  String? propertyid;
  void _getpropertyData() async {
    isLoading.value = true;
    var data = await api.proApiCall();
    isLoading.value = false;
    if (data != null) {
      propertyData.value = data;
    }
  }

  var status = <AvailableStatus>[].obs;
  String? statusid;
  void _getDetailData() async {
    isLoading.value = true;
    var data = await api.bookDetailApiCall(widget.userId!.userId.toString());
    isLoading.value = false;
    if (data != null) {
      status.value = data.availableStatus!;
    }
  }

// ---------------search room -------

  // bool _isChecked = true;
  var records = <Record>[].obs;

  void _getroomData(
      String checkindate, String checkoutdate, String propertyid) async {
    isLoading.value = true;
    var result = await api.availableRoomsApiCall(
        checkindate: checkindate,
        checkoutdate: checkoutdate,
        propertyid: propertyid);
    isLoading.value = false;
    if (result != null) {
      records.value = result.records!;
      var data = await _modalBottomSheetMenu();
      if (data != null) {
        ids = data;
        // print('ids- $ids');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: customText("Edit Booking ", 14.sp, textColor: white),
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
                      controller: _username,
                      decoration: myInputDecoration(hintText: "User Name"),
                    ),
                    SizedBox(height: 20.h),
                    DropdownButtonFormField<String>(
                      decoration: myInputDecoration(hintText: "Status"),
                      items: status
                          .map((value) => DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Text(" ${value.name}")))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          statusid = value!.toString();
                          //  print(propertyid);
                        });
                      },
                      value: statusid,
                    ),
                    SizedBox(height: 20.h),
                    DropdownButtonFormField<String>(
                      decoration:
                          myInputDecoration(hintText: "Search Property"),
                      items: propertyData
                          .map((value) => DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Text(" ${value.name}")))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          propertyid = value!.toString();
                          //  print(propertyid);
                        });
                      },
                      value: propertyid,
                    ),
                    SizedBox(height: 20.h),
                    customText("Checkin", 14.sp),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: _checkindate,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Please Select Date';
                              }
                              return null;
                            },
                            decoration:
                                myInputDecoration(hintText: "Select Date"),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                lastDate: DateTime(2100),
                                firstDate: DateTime.now(),
                                initialDate:
                                    DateTime.now().add(const Duration(days: 0)),
                              );
                              if (pickedDate != null) {
                                String datetime1 =
                                    DateFormat("yyyy-MM-dd").format(pickedDate);
                                _checkindate.text = datetime1;
                                // print(_checkindate);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            readOnly: true,
                            controller: _checkintime,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Please Select Time';
                              }
                              return null;
                            },
                            decoration: myInputDecoration(hintText: "Time"),
                            onTap: () async {
                              var time = await showTimePicker(
                                  // builder: (context, child) => MediaQuery(
                                  //     data: MediaQuery.of(context)
                                  //         .copyWith(alwaysUse24HourFormat: true),
                                  //     child: child!),
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (time != null) {
                                // var _time = DateTime.now().toUtc();
                                // ignore: use_build_context_synchronously
                                _checkintime.text = time.format(context);
                                //_time.text = time.format(context);
                                var df = DateFormat("h:mm a");
                                var dt = df.parse(time.format(context));
                                setState(() {
                                  timein = DateFormat('HH:mm').format(dt);
                                  // print("Time");
                                  // print(timein);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    customText("Checkout", 14.sp),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            readOnly: true,
                            controller: _checkoutdate,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Please Select Date';
                              }
                              return null;
                            },
                            decoration:
                                myInputDecoration(hintText: "Select Date"),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                lastDate: DateTime(2100),
                                firstDate: DateTime.now(),
                                initialDate:
                                    DateTime.now().add(const Duration(days: 0)),
                              );

                              if (pickedDate != null) {
                                String datetime1 =
                                    DateFormat("yyyy-MM-dd").format(pickedDate);
                                _checkoutdate.text = datetime1;
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            readOnly: true,
                            controller: _checkouttime,
                            validator: (val) {
                              if (val!.trim().isEmpty) {
                                return 'Please Select Time';
                              }
                              return null;
                            },
                            decoration: myInputDecoration(hintText: "Time"),
                            onTap: () async {
                              var time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (time != null) {
                                _checkouttime.text = time.format(context);

                                var df = DateFormat("h:mm a");
                                var dt = df.parse(time.format(context));
                                setState(() {
                                  timeout = DateFormat('HH:mm').format(dt);
                                  // print("Time");
                                  // print(timeout);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _getroomData(_checkindate.text, _checkoutdate.text,
                              propertyid.toString());
                        }
                      },
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search, color: white),
                            SizedBox(width: 10.w),
                            customText(" Fetch Available Rooms", 14.sp,
                                textColor: white),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // customText("Available Room", 14.sp),
                    // customText(ids, 14.sp),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Booking For',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Row(
                            children: [
                              Radio(
                                value: 0,
                                groupValue: radioButtonid,
                                onChanged: (val) {
                                  setState(() {
                                    radioButtonItem = 'Self';
                                    radioButtonid = 0;
                                    hide = false;
                                  });
                                },
                              ),
                              const Text(
                                'Self',
                                style: TextStyle(fontSize: 17.0),
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
                                    radioButtonItem = 'Others';
                                    radioButtonid = 1;
                                    hide = true;
                                  });
                                },
                              ),
                              const Text(
                                'Others',
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    widget.userId!.bookingForId == 1
                        ? Visibility(
                            visible: true,
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),
                                TextFormField(
                                  controller: _bookingguest,
                                  decoration: myInputDecoration(
                                      hintText: "Booking Guest"),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(height: 1.h),
                    SizedBox(height: 20.h),
                    TextFormField(
                      controller: _purpose,
                      decoration:
                          myInputDecoration(hintText: "Purpose of Visit"),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _adult,
                            decoration: myInputDecoration(hintText: "Adult"),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _child,
                            decoration: myInputDecoration(hintText: "Child"),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _infant,
                            decoration: myInputDecoration(hintText: "Infant"),
                          ),
                        ),
                      ],
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
                                              color:
                                                  kTextColor.withOpacity(.5)),
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
                                                    BorderRadius.circular(
                                                        50.r)),
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
                                              title:
                                                  customText("Gallery", 14.sp),
                                              onTap: () {
                                                _chooseone(ImageSource.gallery);
                                                Get.back();
                                              },
                                            ),
                                            Divider(
                                                color:
                                                    kTextColor.withOpacity(.5),
                                                height: 1),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: kPrimaryColor),
                                              title:
                                                  customText("Camera", 14.sp),
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
                                              color:
                                                  kTextColor.withOpacity(.5)),
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
                                                    BorderRadius.circular(
                                                        50.r)),
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
                                              title:
                                                  customText("Gallery", 14.sp),
                                              onTap: () {
                                                _choosetwo(ImageSource.gallery);
                                                Get.back();
                                              },
                                            ),
                                            Divider(
                                                color:
                                                    kTextColor.withOpacity(.5),
                                                height: 1),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: kPrimaryColor),
                                              title:
                                                  customText("Camera", 14.sp),
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
                                              color:
                                                  kTextColor.withOpacity(.5)),
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
                                                    BorderRadius.circular(
                                                        50.r)),
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
                                              title:
                                                  customText("Gallery", 14.sp),
                                              onTap: () {
                                                _choosethree(
                                                    ImageSource.gallery);
                                                Get.back();
                                              },
                                            ),
                                            Divider(
                                                color:
                                                    kTextColor.withOpacity(.5),
                                                height: 1),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: kPrimaryColor),
                                              title:
                                                  customText("Camera", 14.sp),
                                              onTap: () {
                                                _choosethree(
                                                    ImageSource.camera);
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
                        text: "Update",
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            _update(
                              _bookId.text,
                              _userId.text.toString(),
                              statusid.toString(),
                              propertyid.toString(),
                              _checkindate.text,
                              _checkintime.text,
                              _checkoutdate.text,
                              _checkouttime.text,
                              radioButtonid.toString(),
                              ids,
                              _purpose.text,
                              _adult.text,
                              _child.text,
                              _infant.text,
                              _bookingguest.text,
                              _docone.text,
                              pathoneBase64!,
                              _doctwo.text,
                              pathtwoBase64!,
                              _docthree.text,
                              paththreeBase64!,
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _update(
    String bookId,
    String userId,
    String statusid,
    String propertyid,
    String checkIndate,
    String checkintime,
    String checkoutdate,
    String checkouttime,
    String radioButtonid,
    String ids,
    String purpose,
    String adult,
    String child,
    String infant,
    String bookingguest,
    String docone,
    String onebase,
    String doctwo,
    String twobase,
    String docthree,
    String threebase,
  ) async {
    var result = await api.updateApiCall(
      bookId: bookId,
      userId: userId,
      statusid: statusid,
      propertyid: propertyid,
      checkIndate: checkIndate,
      checkintime: checkintime,
      checkoutdate: checkoutdate,
      checkouttime: checkouttime,
      radioButtonid: radioButtonid,
      ids: ids,
      purpose: purpose,
      adult: adult,
      child: child,
      infant: infant,
      bookingguest: bookingguest,
      docone: docone,
      onebase: onebase,
      doctwo: doctwo,
      twobase: twobase,
      docthree: docthree,
      threebase: threebase,
    );

    if (result != null) {
      // ignore: use_build_context_synchronously
      setState(() {});
      Get.to(() => BookingDetail(bookId: bookId));
      setState(() {});
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

  Future<String?> _modalBottomSheetMenu() async {
    return await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (builder) {
          return StatefulBuilder(builder: (context, mstate) {
            return Container(
                height: .7.sh,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customText("Available Rooms", 14.sp,
                                      fontWeight: FontWeight.w600),
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Icon(Icons.close),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            ColoredBox(
                              color: const Color(0xFFf5f5f5),
                              child: records.length.isEqual(0)
                                  ? Center(
                                      child: customText("No Data", 20.sp,
                                          fontWeight: FontWeight.w800),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      // itemCount: roomlist.value.data?.floor1?.standard?.length,
                                      itemCount: records.length,
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Container(
                                              width: 1.sw,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 10.h),
                                              child: customText(
                                                  "Floor: ${records[index].floor.toString()}",
                                                  14.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                primary: false,
                                                itemCount: records[index]
                                                    .details!
                                                    .length,
                                                itemBuilder: (context, e) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 1.sw,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: Color(
                                                                    0xFFe5e9ec)),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      12.w,
                                                                  vertical:
                                                                      10.h),
                                                          child: customText(
                                                              "${records[index].details![e].category}",
                                                              13.sp),
                                                        ),
                                                      ),
                                                      GridView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          gridDelegate:
                                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                                  childAspectRatio:
                                                                      2.5,
                                                                  crossAxisSpacing:
                                                                      0,
                                                                  mainAxisSpacing:
                                                                      0,
                                                                  crossAxisCount:
                                                                      2),
                                                          itemCount:
                                                              records[index]
                                                                  .details![e]
                                                                  .rooms!
                                                                  .toList()
                                                                  .length,
                                                          itemBuilder:
                                                              (context, i) {
                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                  color: white,
                                                                  border: Border.all(
                                                                      width: .2,
                                                                      color: kTextColor
                                                                          .withOpacity(
                                                                              .3))),
                                                              child:
                                                                  CheckboxListTile(
                                                                title: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        customText(
                                                                            "${records[index].details![e].rooms![i].roomName}",
                                                                            14.sp,
                                                                            fontWeight: FontWeight.w600),
                                                                        customText(
                                                                            "${records[index].details![e].rooms![i].category}",
                                                                            14.sp),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            5.h),
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal: 4
                                                                              .w,
                                                                          vertical:
                                                                              4.h),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                              color: Color(0xFFf0ad4e)),
                                                                      child: customText(
                                                                          "Rs . ${records[index].details![e].rooms![i].price}",
                                                                          14.sp,
                                                                          textColor:
                                                                              white,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    )
                                                                  ],
                                                                ),
                                                                value: _isSelectedRoomId ==
                                                                    (records[index]
                                                                            .details![e]
                                                                            .rooms![i]
                                                                            .id ??
                                                                        0),
                                                                onChanged:
                                                                    (val) {
                                                                  mstate(() {
                                                                    _isSelectedRoomId = records[index]
                                                                            .details![e]
                                                                            .rooms![i]
                                                                            .id ??
                                                                        0;
                                                                  });
                                                                },
                                                                controlAffinity:
                                                                    ListTileControlAffinity
                                                                        .leading,
                                                              ),
                                                            );
                                                          })
                                                    ],
                                                  );
                                                }),
                                          ],
                                        );
                                      }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: DefaultButton(
                          text: "Save",
                          press: () {
                            // var selectedList = [];
                            // for (var element in records) {
                            //   for (var e in element.details!) {
                            //     var result = e.rooms!
                            //         .where((element) => element.isSelected)
                            //         .toList();
                            //     selectedList.addAll(result);
                            //   }
                            // }

                            // if (selectedList.isEmpty) {
                            //   showToast('Please select atleast one room');
                            // } else {
                            //   StringBuffer buffer = StringBuffer();
                            //   for (var element in selectedList) {
                            //     buffer.write(element.id.toString());
                            //     buffer.write(',');
                            //   }

                            if (_isSelectedRoomId == 0) {
                              showToast('Please select one room');
                            }
                            Navigator.pop(
                                context, _isSelectedRoomId.toString());
                            // }
                          }),
                    ),
                  ],
                ));
          });
        });
  }
}
