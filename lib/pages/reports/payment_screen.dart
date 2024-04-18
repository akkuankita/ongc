import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/paymentwise_export_modal.dart';
import 'package:ongcguest_house/network/modal/property_list_modal.dart';
import 'package:ongcguest_house/network/modal/payment_summary_modal.dart';
import 'package:ongcguest_house/pages/my_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  RxBool isLoading = true.obs;
  var propertyData = <PropertyData>[].obs;
  String? _selectedPropertyData;
  final scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _formdate = TextEditingController();
  final _todate = TextEditingController();

  String defaultValue = "";

  @override
  void initState() {
    super.initState();
    _formdate.text = DateTime.now().toString();
    _todate.text = DateTime.now().add(const Duration(days: 7)).toString();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getpropertyData();
      scrollController.addListener(_scrollListener);
    });
  }

  int page = 1;
  bool isLoadingMore = false;
  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      callroomOccupancyeApi();
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

  var roomocc = <SummaryRecord>[].obs;
  var summarydata = Summary().obs;
  void callroomOccupancyeApi() async {
    var result = await api.roomOccupancyApiCall(
      formdate: _formdate.text,
      todate: _todate.text,
      property: _selectedPropertyData,
      page: page,
    );
    if (result != null) {
      roomocc.addAll(result.records!);
      //roomocc.value = result.records!;
      summarydata.value = result.summary!;
    }
  }

  var exportwise = PaymentWiseExportData().obs;

  void _exportReportApi() async {
    var result = await api.paymentwiseExportApiCall(
        formdate: _formdate.text,
        todate: _todate.text,
        property: _selectedPropertyData);
    if (result != null) {
      exportwise.value = result;
      _addPhotoDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value
          ? Center(child: CupertinoActivityIndicator(radius: 20.r))
          : Scaffold(
              backgroundColor: white,
              appBar: AppBar(
                title: customText("Payment", 14.sp, textColor: white),
                actions: [
                  InkWell(
                      // onTap: () async {
                      //   final Uri url =
                      //       Uri.parse(exportwise.value.downloadUrl.toString());
                      //   print(url);
                      //   if (!await launchUrl(url)) {
                      //     throw Exception('Could not launch ');
                      //   }
                      // },
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _exportReportApi();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 19.h),
                        child: const Text("Export Excel"),
                      )),
                  SizedBox(width: 25.w),
                ],
              ),
              drawer: const MyDrawer(),
              body: SafeArea(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 16.w, top: 15.h, right: 16.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    decoration: myInputDecoration(
                                        hintText: "Search Property"),
                                    items: propertyData
                                        .map(
                                            (value) => DropdownMenuItem<String>(
                                                value: value.id.toString(),
                                                child: Text(
                                                  " ${value.name},",
                                                  style: TextStyle(
                                                      fontSize: 14.sp),
                                                )))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPropertyData =
                                            value!.toString();
                                        //   print(_selectedPropertyData);
                                      });
                                    },
                                    value: _selectedPropertyData,
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Color(0xFFF5F7F9)),
                                          child: TextFormField(
                                            controller: _formdate,
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
                                                _formdate.text = datetime1;
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
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  callroomOccupancyeApi();
                                }
                              },
                              child: Container(
                                width: 42.w,
                                height: 100.w,
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
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16.w, top: 15.h, right: 16.w, bottom: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: .28.sw,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: kPrimarylightColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customText("Room\nOccupancy", 14.sp,
                                    align: TextAlign.center, maxLine: 2),
                                customText(
                                    "${summarydata.value.roomOccupancy}", 22,
                                    fontWeight: FontWeight.w800)
                              ],
                            ),
                          ),
                          Container(
                            width: .28.sw,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: kPrimarylightColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customText("Rent\nReceived", 14.sp,
                                    align: TextAlign.center, maxLine: 2),
                                customText(
                                    "Rs. ${summarydata.value.rentAmount}", 22,
                                    fontWeight: FontWeight.w800)
                              ],
                            ),
                          ),
                          Container(
                            width: .28.sw,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: kPrimarylightColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customText("Food Bill\nReceived", 14.sp,
                                    align: TextAlign.center, maxLine: 2),
                                customText(
                                    "Rs. ${summarydata.value.foodAmount}", 22,
                                    fontWeight: FontWeight.w800)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                                isScrollable: true,
                                labelColor: kPrimaryColor,
                                unselectedLabelColor: const Color(0xFF505050),
                                indicatorColor:
                                    const Color.fromARGB(255, 85, 112, 37),
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp),
                                unselectedLabelStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp),
                                tabs: const [
                                  Tab(
                                    child: Text('Room Occupancy'),
                                  ),
                                  Tab(
                                    child: Text('Rent Received'),
                                  ),
                                  Tab(
                                    child: Text('Food Bill Received'),
                                  ),
                                ]),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  roomocc.length.isEqual(0)
                                      ? Center(
                                          child: customText("No Data", 20.sp,
                                              fontWeight: FontWeight.w800),
                                        )
                                      : ListView.separated(
                                          controller: scrollController,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 12.h);
                                          },
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 16.h),
                                          itemCount: isLoadingMore
                                              ? roomocc.length + 1
                                              : roomocc.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index < roomocc.length) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4.w,
                                                    vertical: 4.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 12.h),
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 4.0,
                                                        spreadRadius: 2),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        customText(
                                                            "Check In", 14.sp,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            textColor:
                                                                kPrimaryColor),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "${roomocc[index].checkin}",
                                                            14.sp),
                                                        //  const Spacer(),
                                                        //  customText(
                                                        //    "${roomocc[index].bookFor}",
                                                        //    14.sp,
                                                        //    fontWeight: FontWeight.w800,
                                                        //  ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        roomocc[index]
                                                                .userPhoto!
                                                                .isNotEmpty
                                                            ? Container(
                                                                width: 90.w,
                                                                height: 90.w,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: border
                                                                            .withOpacity(.5))),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width: 90.w,
                                                                    height:
                                                                        90.w,
                                                                    imageUrl: roomocc[
                                                                            index]
                                                                        .userPhoto
                                                                        .toString(),
                                                                    progressIndicatorBuilder: (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        Center(
                                                                      child: CircularProgressIndicator(
                                                                          value: downloadProgress
                                                                              .progress,
                                                                          color:
                                                                              kPrimaryColor),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Center(
                                                                      child: customText(
                                                                          "${roomocc[index].name![0].capitalize}",
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
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: border
                                                                            .withOpacity(.5))),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child: Image.asset(
                                                                      "assets/images/pro.jpg",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width:
                                                                          90.w,
                                                                      height:
                                                                          90.w),
                                                                ),
                                                              ),
                                                        SizedBox(width: 13.w),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .person,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].name}",
                                                                    14.sp,
                                                                    maxLine: 2),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.mail,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].userEmail}",
                                                                    14.sp),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.phone,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].userMobile}",
                                                                    14.sp),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .credit_card,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].userEmployeeId}",
                                                                    14.sp),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    //  Row(
                                                    //    crossAxisAlignment:
                                                    //        CrossAxisAlignment.start,
                                                    //    children: [
                                                    //      const Icon(Icons.business,
                                                    //          color: kPrimaryColor, size: 20),
                                                    //      SizedBox(width: 5.w),
                                                    //      Expanded(
                                                    //        child: customText(
                                                    //            "${roomocc[index].companyName}",
                                                    //            14.sp,
                                                    //            maxLine: 3),
                                                    //      ),
                                                    //    ],
                                                    //  ),
                                                    //  SizedBox(height: 8.h),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(Icons.map,
                                                            color:
                                                                kPrimaryColor,
                                                            size: 20),
                                                        SizedBox(width: 5.w),
                                                        Expanded(
                                                          child: customText(
                                                              "${roomocc[index].property}",
                                                              14.sp,
                                                              maxLine: 3),
                                                        ),
                                                        const Icon(Icons.bed,
                                                            color:
                                                                kPrimaryColor,
                                                            size: 20),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "${roomocc[index].room}",
                                                            14.sp),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    //  Row(
                                                    //    crossAxisAlignment:
                                                    //        CrossAxisAlignment.center,
                                                    //    mainAxisAlignment:
                                                    //        MainAxisAlignment.center,
                                                    //    children: [
                                                    //      customText("Rent :", 14.sp,
                                                    //          fontWeight: FontWeight.w800),
                                                    //      SizedBox(width: 5.w),
                                                    //      customText(
                                                    //          "Rs. ${roomocc[index].rentAmount}",
                                                    //          14.sp),
                                                    //      const Spacer(),
                                                    //      customText("Food :", 14.sp,
                                                    //          fontWeight: FontWeight.w800),
                                                    //      SizedBox(width: 5.w),
                                                    //      customText(
                                                    //          "Rs. ${roomocc[index].foodAmount}",
                                                    //          14.sp),
                                                    //    ],
                                                    //  ),
                                                    //  SizedBox(height: 8.h),
                                                    Row(
                                                      children: [
                                                        customText(
                                                            "Check Out", 14.sp,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            textColor: red),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "${roomocc[index].checkout}",
                                                            14.sp),
                                                        const Spacer(),
                                                        customText(
                                                          "${roomocc[index].status}",
                                                          14.sp,
                                                          textColor: roomocc[
                                                                          index]
                                                                      .status ==
                                                                  "Checked Out"
                                                              ? kPrimaryColor
                                                              : red,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }),
                                  roomocc.length.isEqual(0)
                                      ? Center(
                                          child: customText("No Data", 20.sp,
                                              fontWeight: FontWeight.w800),
                                        )
                                      : ListView.separated(
                                          controller: scrollController,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 12.h);
                                          },
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 16.h),
                                          itemCount: isLoadingMore
                                              ? roomocc.length + 1
                                              : roomocc.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index < roomocc.length) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4.w,
                                                    vertical: 4.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 12.h),
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 4.0,
                                                        spreadRadius: 2),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        customText(
                                                            "Check In", 14.sp,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            textColor:
                                                                kPrimaryColor),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "${roomocc[index].checkin}",
                                                            14.sp),
                                                        //  const Spacer(),
                                                        //  customText(
                                                        //    "${roomocc[index].bookFor}",
                                                        //    14.sp,
                                                        //    fontWeight: FontWeight.w800,
                                                        //  ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        roomocc[index]
                                                                .userPhoto!
                                                                .isNotEmpty
                                                            ? Container(
                                                                width: 90.w,
                                                                height: 90.w,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: border
                                                                            .withOpacity(.5))),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width: 90.w,
                                                                    height:
                                                                        90.w,
                                                                    imageUrl: roomocc[
                                                                            index]
                                                                        .userPhoto
                                                                        .toString(),
                                                                    progressIndicatorBuilder: (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        Center(
                                                                      child: CircularProgressIndicator(
                                                                          value: downloadProgress
                                                                              .progress,
                                                                          color:
                                                                              kPrimaryColor),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Center(
                                                                      child: customText(
                                                                          "${roomocc[index].name![0].capitalize}",
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
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: border
                                                                            .withOpacity(.5))),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child: Image.asset(
                                                                      "assets/images/pro.jpg",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width:
                                                                          90.w,
                                                                      height:
                                                                          90.w),
                                                                ),
                                                              ),
                                                        SizedBox(width: 13.w),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .person,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].name}",
                                                                    14.sp,
                                                                    maxLine: 2),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.mail,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].userEmail}",
                                                                    14.sp),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.phone,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].userMobile}",
                                                                    14.sp),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .credit_card,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].userEmployeeId}",
                                                                    14.sp),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    //  Row(
                                                    //    crossAxisAlignment:
                                                    //        CrossAxisAlignment.start,
                                                    //    children: [
                                                    //      const Icon(Icons.business,
                                                    //          color: kPrimaryColor, size: 20),
                                                    //      SizedBox(width: 5.w),
                                                    //      Expanded(
                                                    //        child: customText(
                                                    //            "${roomocc[index].companyName}",
                                                    //            14.sp,
                                                    //            maxLine: 3),
                                                    //      ),
                                                    //    ],
                                                    //  ),
                                                    //  SizedBox(height: 8.h),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(Icons.map,
                                                            color:
                                                                kPrimaryColor,
                                                            size: 20),
                                                        SizedBox(width: 5.w),
                                                        Expanded(
                                                          child: customText(
                                                              "${roomocc[index].property}",
                                                              14.sp,
                                                              maxLine: 3),
                                                        ),
                                                        const Icon(Icons.bed,
                                                            color:
                                                                kPrimaryColor,
                                                            size: 20),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "${roomocc[index].room}",
                                                            14.sp),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        customText(
                                                            "Rent :", 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "Rs. ${roomocc[index].rentAmount}",
                                                            14.sp),
                                                        const Spacer(),
                                                        //  customText("Food :", 14.sp,
                                                        //      fontWeight: FontWeight.w800),
                                                        //  SizedBox(width: 5.w),
                                                        //  customText(
                                                        //      "Rs. ${roomocc[index].foodAmount}",
                                                        //      14.sp),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Row(
                                                      children: [
                                                        customText(
                                                            "Check Out", 14.sp,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            textColor: red),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "${roomocc[index].checkout}",
                                                            14.sp),
                                                        const Spacer(),
                                                        customText(
                                                          "${roomocc[index].status}",
                                                          14.sp,
                                                          textColor: roomocc[
                                                                          index]
                                                                      .status ==
                                                                  "Checked Out"
                                                              ? kPrimaryColor
                                                              : red,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }),
                                  roomocc.length.isEqual(0)
                                      ? Center(
                                          child: customText("No Data", 20.sp,
                                              fontWeight: FontWeight.w800),
                                        )
                                      : ListView.separated(
                                          controller: scrollController,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 12.h);
                                          },
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w, vertical: 16.h),
                                          itemCount: isLoadingMore
                                              ? roomocc.length + 1
                                              : roomocc.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            if (index < roomocc.length) {
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 4.w,
                                                    vertical: 4.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 12.h),
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 4.0,
                                                        spreadRadius: 2),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        customText(
                                                            "Check In", 14.sp,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            textColor:
                                                                kPrimaryColor),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "${roomocc[index].checkin}",
                                                            14.sp),
                                                        //  const Spacer(),
                                                        //  customText(
                                                        //    "${roomocc[index].bookFor}",
                                                        //    14.sp,
                                                        //    fontWeight: FontWeight.w800,
                                                        //  ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        roomocc[index]
                                                                .userPhoto!
                                                                .isNotEmpty
                                                            ? Container(
                                                                width: 90.w,
                                                                height: 90.w,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: border
                                                                            .withOpacity(.5))),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width: 90.w,
                                                                    height:
                                                                        90.w,
                                                                    imageUrl: roomocc[
                                                                            index]
                                                                        .userPhoto
                                                                        .toString(),
                                                                    progressIndicatorBuilder: (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        Center(
                                                                      child: CircularProgressIndicator(
                                                                          value: downloadProgress
                                                                              .progress,
                                                                          color:
                                                                              kPrimaryColor),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Center(
                                                                      child: customText(
                                                                          "${roomocc[index].name![0].capitalize}",
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
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    border: Border.all(
                                                                        width:
                                                                            1,
                                                                        color: border
                                                                            .withOpacity(.5))),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child: Image.asset(
                                                                      "assets/images/pro.jpg",
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      width:
                                                                          90.w,
                                                                      height:
                                                                          90.w),
                                                                ),
                                                              ),
                                                        SizedBox(width: 13.w),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .person,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].name}",
                                                                    14.sp,
                                                                    maxLine: 2),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.mail,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].userEmail}",
                                                                    14.sp),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.phone,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].userMobile}",
                                                                    14.sp),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 6.h),
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .credit_card,
                                                                    color:
                                                                        kPrimaryColor,
                                                                    size: 20),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                customText(
                                                                    "${roomocc[index].userEmployeeId}",
                                                                    14.sp),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    //  Row(
                                                    //    crossAxisAlignment:
                                                    //        CrossAxisAlignment.start,
                                                    //    children: [
                                                    //      const Icon(Icons.business,
                                                    //          color: kPrimaryColor, size: 20),
                                                    //      SizedBox(width: 5.w),
                                                    //      Expanded(
                                                    //        child: customText(
                                                    //            "${roomocc[index].companyName}",
                                                    //            14.sp,
                                                    //            maxLine: 3),
                                                    //      ),
                                                    //    ],
                                                    //  ),
                                                    //  SizedBox(height: 8.h),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(Icons.map,
                                                            color:
                                                                kPrimaryColor,
                                                            size: 20),
                                                        SizedBox(width: 5.w),
                                                        Expanded(
                                                          child: customText(
                                                              "${roomocc[index].property}",
                                                              14.sp,
                                                              maxLine: 3),
                                                        ),
                                                        const Icon(Icons.bed,
                                                            color:
                                                                kPrimaryColor,
                                                            size: 20),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "${roomocc[index].room}",
                                                            14.sp),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        customText(
                                                            "Rent :", 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "Rs. ${roomocc[index].rentAmount}",
                                                            14.sp),
                                                        const Spacer(),
                                                        customText(
                                                            "Food :", 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "Rs. ${roomocc[index].foodAmount}",
                                                            14.sp),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Row(
                                                      children: [
                                                        customText(
                                                            "Check Out", 14.sp,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            textColor: red),
                                                        SizedBox(width: 5.w),
                                                        customText(
                                                            "${roomocc[index].checkout}",
                                                            14.sp),
                                                        const Spacer(),
                                                        customText(
                                                          "${roomocc[index].status}",
                                                          14.sp,
                                                          textColor: roomocc[
                                                                          index]
                                                                      .status ==
                                                                  "Checked Out"
                                                              ? kPrimaryColor
                                                              : red,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _addPhotoDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: 1.sw,
                  height: 42.h,
                  child: DefaultButton(
                    text: "Download Export",
                    press: () async {
                      final Uri url =
                          Uri.parse(exportwise.value.downloadUrl.toString());
                      //   print(url);
                      if (!await launchUrl(url)) {
                        throw Exception('Could not launch ');
                      }
                    },
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          );
        });
  }
}
