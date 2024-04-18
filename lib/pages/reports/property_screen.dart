import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/property_list_modal.dart';
import 'package:ongcguest_house/network/modal/property_wise_modal.dart';
import 'package:ongcguest_house/network/modal/room_list_modal.dart';
import 'package:ongcguest_house/pages/my_drawer.dart';

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({super.key});

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  RxBool isLoading = true.obs;
  bool isLoadingMore = false;
  final scrollController = ScrollController();
  var propertyData = <PropertyData>[].obs;
  var roomData = <RoomData>[].obs;
  final _formKey = GlobalKey<FormState>();
  final _todate = TextEditingController();
  final _fromDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    _todate.text = DateTime.now().toString();
    _fromDate.text = DateTime.now().add(const Duration(days: -7)).toString();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getpropertyData();
      _propertywise();
      scrollController.addListener(_scrollListener);
    });
  }

  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      _propertywise();
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _getpropertyData() async {
    isLoading.value = true;
    var data = await api.proApiCall();
    isLoading.value = false;
    if (data != null) {
      propertyData.value = data;
    }
  }

  void _getroomData() async {
    isLoading.value = true;
    var data = await api.roomApiCall(propertyId.toString());
    isLoading.value = false;
    if (data != null) {
      roomData.value = data;
    }
  }

  String? propertyId;
  String? roomId;

  int page = 1;

  var propertyrep = <PropertyWiseData>[].obs;
  void _propertywise() async {
    var result = await api.propertyWiserepApiCall(
        propertyId, roomId, _fromDate.text, _todate.text, page.toString());
    if (result != null) {
      propertyrep.addAll(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: customText("Property", 14.sp, textColor: white),
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => isLoading.value
                  ? Center(child: CupertinoActivityIndicator(radius: 20.r))
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 18.h),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          decoration: myInputDecoration(
                                              hintText: "Search Property"),
                                          items: propertyData
                                              .map((value) => DropdownMenuItem<
                                                      String>(
                                                  value: value.id.toString(),
                                                  child:
                                                      Text(" ${value.name}")))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              propertyId = value!.toString();
                                              roomId = null;
                                              roomData.clear();
                                            });
                                            _getroomData();
                                          },
                                          value: propertyId,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                            decoration: myInputDecoration(
                                                hintText: "Select Room"),
                                            items: roomData
                                                .map((value) =>
                                                    DropdownMenuItem<String>(
                                                        value:
                                                            value.id.toString(),
                                                        child: Text(
                                                            "${value.name}")))
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                roomId = value!.toString();
                                                // print(roomId);
                                              });
                                            },
                                            value: roomId),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Color(0xFFF5F7F9)),
                                          child: TextFormField(
                                            controller: _fromDate,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    top: 15.h, left: 12.w),
                                                hintText: "",
                                                suffixIcon: const Icon(
                                                    Icons.calendar_month,
                                                    size: 20,
                                                    color: kPrimaryColor)),
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1200),
                                                lastDate: DateTime(2100),
                                              );

                                              if (pickedDate != null) {
                                                String datetime1 =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(pickedDate);
                                                _fromDate.text = datetime1;
                                              } else {}
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Color(0xFFF5F7F9)),
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: _todate,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    top: 15.h, left: 12.w),
                                                hintText: "",
                                                suffixIcon: const Icon(
                                                    Icons.calendar_month,
                                                    size: 20,
                                                    color: kPrimaryColor)),
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1200),
                                                lastDate: DateTime(2100),
                                              );

                                              if (pickedDate != null) {
                                                String datetime1 =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(pickedDate);
                                                _todate.text = datetime1;
                                                //  print(pickedDate);
                                                // setState(() {
                                                //   changeDate =
                                                //       DateFormat("dd-MMMM-yyyy").format(pickedDate);
                                                //   print(changeDate);
                                                // });
                                              } else {}
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _propertywise();
                                }
                              },
                              child: Container(
                                width: 42.w,
                                height: 109.w,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(4.r)),
                                child: const Icon(Icons.search,
                                    color: white, size: 22),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
            Obx(() {
              return Expanded(
                child: propertyrep.length.isEqual(0)
                    ? Center(
                        child: customText("No Data", 20.sp,
                            fontWeight: FontWeight.w800),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12.h);
                        },
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: isLoadingMore
                            ? propertyrep.length + 1
                            : propertyrep.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < propertyrep.length) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 4.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                color: white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4.0,
                                      spreadRadius: 2),
                                ],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText("Check In", 14.sp,
                                          fontWeight: FontWeight.w800,
                                          textColor: kPrimaryColor),
                                      SizedBox(width: 5.w),
                                      customText(
                                          "${propertyrep[index].checkin}",
                                          14.sp),
                                      const Spacer(),
                                      Flexible(
                                        child: Text(
                                          "${propertyrep[index].bookFor}",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      propertyrep[index].userPhoto!.isNotEmpty
                                          ? Container(
                                              width: 90.w,
                                              height: 90.w,
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  color: white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: border
                                                          .withOpacity(.5))),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  width: 90.w,
                                                  height: 90.w,
                                                  imageUrl: propertyrep[index]
                                                      .userPhoto
                                                      .toString(),
                                                  progressIndicatorBuilder:
                                                      (context, url,
                                                              downloadProgress) =>
                                                          Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress,
                                                            color:
                                                                kPrimaryColor),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Center(
                                                    child: customText(
                                                        "${propertyrep[index].name![0].capitalize}",
                                                        22.sp,
                                                        textColor:
                                                            kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 90.w,
                                              height: 90.w,
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  color: white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: border
                                                          .withOpacity(.5))),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.asset(
                                                    "assets/images/pro.jpg",
                                                    fit: BoxFit.cover,
                                                    width: 90.w,
                                                    height: 90.w),
                                              ),
                                            ),
                                      SizedBox(width: 13.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.person,
                                                    color: kPrimaryColor,
                                                    size: 20),
                                                SizedBox(width: 5.w),
                                                Flexible(
                                                  child: Text(
                                                    "${propertyrep[index].name}",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: kTextColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6.h),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.mail,
                                                    color: kPrimaryColor,
                                                    size: 20),
                                                SizedBox(width: 5.w),
                                                Flexible(
                                                  child: Text(
                                                    "${propertyrep[index].userEmail}",
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: kTextColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6.h),
                                            Row(
                                              children: [
                                                const Icon(Icons.phone,
                                                    color: kPrimaryColor,
                                                    size: 20),
                                                SizedBox(width: 5.w),
                                                customText(
                                                    "${propertyrep[index].userMobile}",
                                                    14.sp),
                                              ],
                                            ),
                                            SizedBox(height: 6.h),
                                            Row(
                                              children: [
                                                const Icon(Icons.credit_card,
                                                    color: kPrimaryColor,
                                                    size: 20),
                                                SizedBox(width: 5.w),
                                                customText(
                                                    "${propertyrep[index].userEmployeeId}",
                                                    14.sp),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.business,
                                          color: kPrimaryColor, size: 20),
                                      SizedBox(width: 5.w),
                                      Expanded(
                                        child: customText(
                                            "${propertyrep[index].companyName}",
                                            14.sp,
                                            maxLine: 3),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.map,
                                          color: kPrimaryColor, size: 20),
                                      SizedBox(width: 5.w),
                                      Expanded(
                                        child: customText(
                                            "${propertyrep[index].property}",
                                            14.sp,
                                            maxLine: 3),
                                      ),
                                      const Icon(Icons.bed,
                                          color: kPrimaryColor, size: 20),
                                      SizedBox(width: 5.w),
                                      customText(
                                          "${propertyrep[index].room}", 14.sp),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customText("Rent :", 14.sp,
                                          fontWeight: FontWeight.w800),
                                      SizedBox(width: 5.w),
                                      customText(
                                          "Rs. ${propertyrep[index].rentAmount}",
                                          14.sp),
                                      const Spacer(),
                                      customText("Food :", 14.sp,
                                          fontWeight: FontWeight.w800),
                                      SizedBox(width: 5.w),
                                      customText(
                                          "Rs. ${propertyrep[index].foodAmount}",
                                          14.sp),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      customText("Check Out", 14.sp,
                                          fontWeight: FontWeight.w800,
                                          textColor: red),
                                      SizedBox(width: 5.w),
                                      customText(
                                          "${propertyrep[index].checkout}",
                                          14.sp),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      customText(
                                        "${propertyrep[index].status}",
                                        14.sp,
                                        textColor: propertyrep[index].status ==
                                                "Checked Out"
                                            ? kPrimaryColor
                                            : red,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
              );
            }),
          ],
        ),
      ),
    );
  }
}
