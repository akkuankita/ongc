// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:ongcguest_house/constants.dart';
// import 'package:ongcguest_house/network/api.dart';
// import 'package:ongcguest_house/network/modal/available_rooms_modal.dart';
// import 'package:ongcguest_house/network/modal/document_model.dart';
// import 'package:ongcguest_house/network/modal/property_list_modal.dart';
// import 'package:ongcguest_house/pages/searchguest_list.dart';

// class AddBookingScreen extends StatefulWidget {
//   final String guestId, guestname;

//   const AddBookingScreen(
//       {super.key, required this.guestId, required this.guestname});

//   @override
//   State<AddBookingScreen> createState() => _AddBookingScreenState();
// }

// class _AddBookingScreenState extends State<AddBookingScreen> {
//   RxBool isLoading = true.obs;
//   final ImagePicker _picker = ImagePicker();
//   File? imgPath;
//   String? imageBase64 = '';
//   final _formKey = GlobalKey<FormState>();
//   final _checkindate = TextEditingController();
//   final _checkintime = TextEditingController();
//   final _checkoutdate = TextEditingController();
//   final _checkouttime = TextEditingController();
//   // final _guestname = TextEditingController();
//   final _bookingguest = TextEditingController();
//   final _purpose = TextEditingController();
//   final _adult = TextEditingController();
//   final _child = TextEditingController();
//   final _infant = TextEditingController();

//   final List<DocumentModel> _docName = [];
//   // final List<DocumentModel> _docPhoto = [];

//   _addfield() {
//     setState(() {
//       _docName.add(DocumentModel(docName: 'docName', docPhoto: 'imageBase64'));
//       // print(imageBase64);
//     });
//   }

//   // ignore: prefer_typing_uninitialized_variables
//   var time24;
//   bool hide = false;
//   String radioButtonItem = 'Self', ids = '';
//   int radioButtonid = 1;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _getpropertyData();
//       _addfield();
//     });
//   }

// // ---------------search room -------

//   // bool _isChecked = true;
//   var records = <Record>[].obs;
//   void _getroomData(
//       String checkindate, String checkoutdate, String propertyid) async {
//     isLoading.value = true;
//     var result = await api.availableRoomsApiCall(
//         checkindate: checkindate,
//         checkoutdate: checkoutdate,
//         propertyid: propertyid);
//     isLoading.value = false;
//     if (result != null) {
//       records.value = result.records!;
//       var data = await _modalBottomSheetMenu();
//       if (data != null) {
//         ids = data;
//         // print('ids- $ids');
//       }
//     }
//   }

// // --------------------propertyData------------

//   var propertyData = <PropertyData>[].obs;
//   String? propertyid;
//   void _getpropertyData() async {
//     isLoading.value = true;
//     var data = await api.proApiCall();
//     isLoading.value = false;
//     if (data != null) {
//       propertyData.value = data;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Scaffold(
//         backgroundColor: white,
//         appBar: AppBar(
//           title: customText("Room Booking ", 14.sp, textColor: white),
//         ),
//         // drawer: const MyDrawer(),
//         body: SafeArea(
//           child: ListView(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Get.to(() =>
//                               const SearchGuestList(categoryTitle: "booking"));
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 15.h),
//                           decoration: BoxDecoration(
//                               color: white,
//                               borderRadius: BorderRadius.circular(4.r),
//                               border: Border.all(
//                                   width: 1, color: const Color(0xFFCCCCCC))),
//                           child: Row(
//                             children: [
//                               widget.guestname.isEmpty
//                                   ? Text(
//                                       "Search Guest",
//                                       style: TextStyle(
//                                           color: Colors.black.withOpacity(.7),
//                                           fontSize: 14.sp,
//                                           fontFamily: "OpenSansRegular"),
//                                     )
//                                   : Text(
//                                       widget.guestname,
//                                       style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 14.sp,
//                                           fontWeight: FontWeight.w500,
//                                           fontFamily: "OpenSansRegular"),
//                                     ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       DropdownButtonFormField<String>(
//                         decoration:
//                             myInputDecoration(hintText: "Search Property"),
//                         items: propertyData
//                             .map((value) => DropdownMenuItem<String>(
//                                 value: value.id.toString(),
//                                 child: Text(" ${value.name}")))
//                             .toList(),
//                         onChanged: (value) {
//                           setState(() {
//                             propertyid = value!.toString();
//                             //  print(propertyid);
//                           });
//                         },
//                         value: propertyid,
//                       ),
//                       SizedBox(height: 15.h),
//                       customText("Checkin", 14.sp),
//                       SizedBox(height: 20.h),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: _checkindate,
//                               validator: (val) {
//                                 if (val!.trim().isEmpty) {
//                                   return 'Please Select Date';
//                                 }
//                                 return null;
//                               },
//                               decoration:
//                                   myInputDecoration(hintText: "Select Date"),
//                               onTap: () async {
//                                 DateTime? pickedDate = await showDatePicker(
//                                   context: context,
//                                   lastDate: DateTime(2100),
//                                   firstDate: DateTime.now(),
//                                   initialDate: DateTime.now()
//                                       .add(const Duration(days: 0)),
//                                 );
//                                 if (pickedDate != null) {
//                                   String datetime1 = DateFormat("yyyy-MM-dd")
//                                       .format(pickedDate);
//                                   _checkindate.text = datetime1;
//                                   // print(_checkindate);
//                                 }
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 20.w),
//                           Expanded(
//                             child: TextFormField(
//                               readOnly: true,
//                               controller: _checkintime,
//                               // validator: (val) {
//                               //   if (val!.trim().isEmpty) {
//                               //     return 'Please Select Time';
//                               //   }
//                               //   return null;
//                               // },
//                               decoration: myInputDecoration(hintText: "Time"),
//                               onTap: () async {
//                                 var time = await showTimePicker(
//                                     context: context,
//                                     initialTime: TimeOfDay.now());
//                                 if (time != null) {
//                                   // ignore: use_build_context_synchronously
//                                   _checkintime.text = time.format(context);
//                                   var df = DateFormat("h:mm a");
//                                   // ignore: use_build_context_synchronously
//                                   var dt = df.parse(time.format(context));
//                                   setState(() {
//                                     time24 = DateFormat('HH:mm').format(dt);
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 15.h),
//                       customText("Checkout", 14.sp),
//                       SizedBox(height: 20.h),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               textCapitalization: TextCapitalization.words,
//                               readOnly: true,
//                               controller: _checkoutdate,
//                               validator: (val) {
//                                 if (val!.trim().isEmpty) {
//                                   return 'Please Select Date';
//                                 }
//                                 return null;
//                               },
//                               decoration:
//                                   myInputDecoration(hintText: "Select Date"),
//                               onTap: () async {
//                                 DateTime? pickedDate = await showDatePicker(
//                                   context: context,
//                                   //   initialDate: DateTime.now(),
//                                   //   firstDate: DateTime.now(),
//                                   //  // firstDate: (DateTime.now()).subtract(Duration(days: 30)),
//                                   lastDate: DateTime(2100),
//                                   firstDate: DateTime.now(),
//                                   // lastDate: DateTime.now().add(new Duration(days: 7)),
//                                   initialDate: DateTime.now()
//                                       .add(const Duration(days: 0)),
//                                 );

//                                 if (pickedDate != null) {
//                                   String datetime1 = DateFormat("yyyy-MM-dd")
//                                       .format(pickedDate);
//                                   _checkoutdate.text = datetime1;
//                                 }
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 20.w),
//                           Expanded(
//                             child: TextFormField(
//                               textCapitalization: TextCapitalization.words,
//                               readOnly: true,
//                               controller: _checkouttime,
//                               decoration: myInputDecoration(hintText: "Time"),
//                               onTap: () async {
//                                 var time = await showTimePicker(
//                                     context: context,
//                                     initialTime: TimeOfDay.now());
//                                 if (time != null) {
//                                   // ignore: use_build_context_synchronously
//                                   _checkouttime.text = time.format(context);

//                                   var df = DateFormat("h:mm a");
//                                   // ignore: use_build_context_synchronously
//                                   var dt = df.parse(time.format(context));
//                                   setState(() {
//                                     time24 = DateFormat('HH:mm').format(dt);
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20.h),
//                       InkWell(
//                         onTap: () {
//                           if (_formKey.currentState!.validate()) {
//                             _getroomData(_checkindate.text, _checkoutdate.text,
//                                 propertyid.toString());
//                           }
//                         },
//                         child: Container(
//                           height: 48.h,
//                           decoration: BoxDecoration(
//                             color: kPrimaryColor,
//                             borderRadius: BorderRadius.circular(8.r),
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(Icons.search, color: white),
//                               SizedBox(width: 10.w),
//                               customText(" Fetch Available Rooms", 14.sp,
//                                   textColor: white),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             const Text(
//                               'Booking For',
//                               style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black),
//                             ),
//                             Row(
//                               children: [
//                                 Radio(
//                                   value: 1,
//                                   groupValue: radioButtonid,
//                                   onChanged: (val) {
//                                     setState(() {
//                                       radioButtonItem = 'Self';
//                                       radioButtonid = 1;
//                                       hide = false;
//                                     });
//                                   },
//                                 ),
//                                 const Text(
//                                   'Self',
//                                   style: TextStyle(fontSize: 17.0),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 Radio(
//                                   value: 2,
//                                   groupValue: radioButtonid,
//                                   onChanged: (val) {
//                                     setState(() {
//                                       radioButtonItem = 'Others';
//                                       radioButtonid = 2;
//                                       hide = true;
//                                     });
//                                   },
//                                 ),
//                                 const Text(
//                                   'Others',
//                                   style: TextStyle(
//                                     fontSize: 17.0,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                       Visibility(
//                         visible: hide,
//                         child: Column(
//                           children: [
//                             SizedBox(height: 20.h),
//                             TextFormField(
//                               controller: _bookingguest,
//                               decoration:
//                                   myInputDecoration(hintText: "Booking Guest"),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       TextFormField(
//                         controller: _purpose,
//                         decoration:
//                             myInputDecoration(hintText: "Purpose of Visit"),
//                       ),
//                       SizedBox(height: 20.h),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               controller: _adult,
//                               decoration: myInputDecoration(hintText: "Adult"),
//                             ),
//                           ),
//                           SizedBox(width: 15.w),
//                           Expanded(
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               controller: _child,
//                               decoration: myInputDecoration(hintText: "Child"),
//                             ),
//                           ),
//                           SizedBox(width: 15.w),
//                           Expanded(
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               controller: _infant,
//                               decoration: myInputDecoration(hintText: "Infant"),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20.h),
//                       customText("Documentation", 14.sp,
//                           fontWeight: FontWeight.w600),
//                       SizedBox(height: 20.h),
//                       ListView.separated(
//                         separatorBuilder: (context, index) {
//                           return SizedBox(height: 15.h);
//                         },
//                         shrinkWrap: true,
//                         itemBuilder: (context, index) {
//                           return Row(
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   onChanged: (value) {
//                                     _docName[index].docName = value;
//                                   },
//                                   decoration: myInputDecoration(
//                                       hintText: "Document Name"),
//                                 ),
//                               ),
//                               SizedBox(width: 20.w),
//                               Expanded(
//                                 child: Container(
//                                   padding:
//                                       EdgeInsets.symmetric(horizontal: 10.w),
//                                   decoration: BoxDecoration(
//                                       color: white,
//                                       border: Border.all(
//                                           width: 1,
//                                           color: const Color(0xFFCCCCCC)),
//                                       borderRadius: BorderRadius.circular(4.r)),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       imgPath == null
//                                           ? Icon(Icons.image,
//                                               size: 30,
//                                               color: kTextColor.withOpacity(.5))
//                                           : Image.file(
//                                               imgPath!,
//                                               fit: BoxFit.cover,
//                                               width: 33.w,
//                                               height: 33.w,
//                                             ),
//                                       IconButton(
//                                           padding: EdgeInsets.zero,
//                                           onPressed: () {
//                                             Get.bottomSheet(ColoredBox(
//                                               color: white,
//                                               child: Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   ListTile(
//                                                     leading: const Icon(
//                                                         Icons.image_outlined,
//                                                         color: kPrimaryColor),
//                                                     title: customText(
//                                                         "Gallery", 14.sp),
//                                                     onTap: () {
//                                                       _chooseImage(
//                                                           ImageSource.gallery);
//                                                       Get.back();
//                                                     },
//                                                   ),
//                                                   Divider(
//                                                       color: kTextColor
//                                                           .withOpacity(.5),
//                                                       height: 1),
//                                                   ListTile(
//                                                     leading: const Icon(
//                                                         Icons
//                                                             .camera_alt_outlined,
//                                                         color: kPrimaryColor),
//                                                     title: customText(
//                                                         "Camera", 14.sp),
//                                                     onTap: () {
//                                                       _chooseImage(
//                                                           ImageSource.camera);
//                                                       Get.back();
//                                                     },
//                                                   ),
//                                                 ],
//                                               ),
//                                             ));
//                                           },
//                                           icon: const Icon(Icons.attach_file,
//                                               size: 20, color: kPrimaryColor)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 12.w),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 2.w, vertical: 2.h),
//                                 decoration: BoxDecoration(
//                                     color: red,
//                                     borderRadius: BorderRadius.circular(50.r)),
//                                 child: InkWell(
//                                     child: const Icon(
//                                       Icons.close,
//                                       color: white,
//                                     ),
//                                     onTap: () {
//                                       _docName.removeAt(index);
//                                       setState(() {});
//                                     }),
//                               ),
//                               // IconButton(
//                               //   color: kPrimaryColor,
//                               //   onPressed: () {
//                               //     _docName.removeAt(index);
//                               //     setState(() {});
//                               //   },
//                               //   icon: Icon(Icons.close),
//                               // )
//                             ],
//                           );
//                         },
//                         itemCount: _docName.length,
//                       ),
//                       SizedBox(height: 14.h),
//                       Row(
//                         children: [
//                           const Spacer(),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 8.w, vertical: 5.h),
//                             decoration: BoxDecoration(
//                                 color: kPrimaryColor,
//                                 borderRadius: BorderRadius.circular(4.r)),
//                             child: InkWell(
//                                 child: customText("Add more", 13.sp,
//                                     textColor: white),
//                                 onTap: () {
//                                   _addfield();
//                                 }),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 20.h),
//                       DefaultButton(
//                           text: "Save",
//                           press: () {
//                             if (_formKey.currentState!.validate()) {
//                               _booking(
//                                 widget.guestId,
//                                 propertyid.toString(),
//                                 _checkindate.text,
//                                 _checkintime.text,
//                                 _checkoutdate.text,
//                                 _checkouttime.text,
//                                 ids,
//                                 _purpose.text,
//                                 _adult.text,
//                                 _child.text,
//                                 _infant.text,
//                                 _bookingguest.text,
//                                 _docName,
//                               );
//                             }
//                           }),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   void _booking(
//     String guestId,
//     String propertyid,
//     String checkIndate,
//     String checkintime,
//     String checkoutdate,
//     String checkouttime,
//     String radioButtonid,
//     String purpose,
//     String adult,
//     String child,
//     String infant,
//     String bookingguest,
//     docName,
//   ) async {
//     var result = await api.bookingcreateApiCall(
//       guestId: guestId,
//       propertyid: propertyid,
//       checkIndate: checkIndate,
//       checkintime: checkintime,
//       checkoutdate: checkoutdate,
//       checkouttime: checkouttime,
//       radioButtonid: radioButtonid,
//       purpose: purpose,
//       adult: adult,
//       child: child,
//       infant: infant,
//       bookingguest: bookingguest,
//       pathList: docName,
//     );
//     if (result != null) {
//       // print("As");
//     }
//   }

//   void _chooseImage(ImageSource source) async {
//     var result = await _picker.pickImage(source: source);
//     if (result != null) {
//       // print(result.path);
//       imgPath = File(result.path);
//       setState(() {});
//     }
//     // Uint8List? imagebytes = await imgPath?.readAsBytes();
//     // String base64string = base64.encode(imagebytes!);
//     // imageBase64 = base64string;
//   }

//   Future<String?> _modalBottomSheetMenu() async {
//     return await showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(20),
//           ),
//         ),
//         builder: (builder) {
//           return StatefulBuilder(builder: (context, mstate) {
//             return Container(
//                 height: .7.sh,
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(10.0),
//                         topRight: Radius.circular(10.0))),
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             SizedBox(height: 20.h),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 16.w),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   customText("Available Rooms", 14.sp,
//                                       fontWeight: FontWeight.w600),
//                                   InkWell(
//                                     onTap: () {
//                                       Get.back();
//                                     },
//                                     child: const Icon(Icons.close),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: 20.h),
//                             ColoredBox(
//                               color: const Color(0xFFf5f5f5),
//                               child: records.length.isEqual(0)
//                                   ? Center(
//                                       child: customText("No Data", 20.sp,
//                                           fontWeight: FontWeight.w800),
//                                     )
//                                   : ListView.builder(
//                                       shrinkWrap: true,
//                                       // itemCount: roomlist.value.data?.floor1?.standard?.length,
//                                       itemCount: records.length,
//                                       primary: false,
//                                       itemBuilder: (context, index) {
//                                         return Column(
//                                           children: [
//                                             Container(
//                                               width: 1.sw,
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 12.w,
//                                                   vertical: 10.h),
//                                               child: customText(
//                                                   "Floor: ${records[index].floor.toString()}",
//                                                   14.sp,
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                             ListView.builder(
//                                                 shrinkWrap: true,
//                                                 primary: false,
//                                                 itemCount: records[index]
//                                                     .details!
//                                                     .length,
//                                                 itemBuilder: (context, e) {
//                                                   return Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Container(
//                                                         width: 1.sw,
//                                                         decoration:
//                                                             const BoxDecoration(
//                                                                 color: Color(
//                                                                     0xFFe5e9ec)),
//                                                         child: Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       12.w,
//                                                                   vertical:
//                                                                       10.h),
//                                                           child: customText(
//                                                               "${records[index].details![e].category}",
//                                                               13.sp),
//                                                         ),
//                                                       ),
//                                                       GridView.builder(
//                                                           shrinkWrap: true,
//                                                           physics:
//                                                               const NeverScrollableScrollPhysics(),
//                                                           gridDelegate:
//                                                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                                                   childAspectRatio:
//                                                                       2.5,
//                                                                   crossAxisSpacing:
//                                                                       0,
//                                                                   mainAxisSpacing:
//                                                                       0,
//                                                                   crossAxisCount:
//                                                                       2),
//                                                           itemCount:
//                                                               records[index]
//                                                                   .details![e]
//                                                                   .rooms!
//                                                                   .toList()
//                                                                   .length,
//                                                           itemBuilder:
//                                                               (context, i) {
//                                                             return Container(
//                                                               decoration: BoxDecoration(
//                                                                   color: white,
//                                                                   border: Border.all(
//                                                                       width: .2,
//                                                                       color: kTextColor
//                                                                           .withOpacity(
//                                                                               .3))),
//                                                               child:
//                                                                   CheckboxListTile(
//                                                                 title: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Row(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .spaceBetween,
//                                                                       children: [
//                                                                         customText(
//                                                                             "${records[index].details![e].rooms![i].roomName}",
//                                                                             14.sp,
//                                                                             fontWeight: FontWeight.w600),
//                                                                         customText(
//                                                                             "${records[index].details![e].rooms![i].category}",
//                                                                             14.sp),
//                                                                       ],
//                                                                     ),
//                                                                     SizedBox(
//                                                                         height:
//                                                                             5.h),
//                                                                     Container(
//                                                                       padding: EdgeInsets.symmetric(
//                                                                           horizontal: 4
//                                                                               .w,
//                                                                           vertical:
//                                                                               4.h),
//                                                                       decoration:
//                                                                           const BoxDecoration(
//                                                                               color: Color(0xFFf0ad4e)),
//                                                                       child: customText(
//                                                                           "Rs . ${records[index].details![e].rooms![i].price}",
//                                                                           14.sp,
//                                                                           textColor:
//                                                                               white,
//                                                                           fontWeight:
//                                                                               FontWeight.w600),
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                                 value: records[
//                                                                         index]
//                                                                     .details![e]
//                                                                     .rooms![i]
//                                                                     .isSelected,
//                                                                 onChanged:
//                                                                     (val) {
//                                                                   mstate(() {
//                                                                     records[index]
//                                                                         .details![
//                                                                             e]
//                                                                         .rooms![
//                                                                             i]
//                                                                         .isSelected = val!;
//                                                                   });
//                                                                 },
//                                                                 controlAffinity:
//                                                                     ListTileControlAffinity
//                                                                         .leading,
//                                                               ),
//                                                             );
//                                                           })
//                                                     ],
//                                                   );
//                                                 }),
//                                           ],
//                                         );
//                                       }),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 15.h),
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 16.w, vertical: 16.h),
//                       child: DefaultButton(
//                           text: "Save",
//                           press: () {
//                             List<Room> selectedList = [];
//                             for (var element in records) {
//                               for (var e in element.details!) {
//                                 var result = e.rooms!
//                                     .where((element) => element.isSelected)
//                                     .toList();
//                                 selectedList.addAll(result);
//                               }
//                             }

//                             if (selectedList.isEmpty) {
//                               showToast('Please select atleast one room');
//                             } else {
//                               StringBuffer buffer = StringBuffer();
//                               for (var element in selectedList) {
//                                 buffer.write(element.id.toString());
//                                 buffer.write(',');
//                               }
//                               Navigator.pop(
//                                   context,
//                                   buffer.toString().substring(
//                                       0, buffer.toString().length - 1));
//                             }
//                           }),
//                     ),
//                   ],
//                 ));
//           });
//         });
//   }
// }
