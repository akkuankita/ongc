import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/book_detail_modal.dart';
import 'package:ongcguest_house/pages/all_booking_screen.dart';
import 'package:ongcguest_house/pages/edit_booking.dart';

class BookingDetail extends StatefulWidget {
  final String bookId;
  const BookingDetail({super.key, required this.bookId});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {
  RxBool isLoading = true.obs;
  bool isLoadingMore = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getDetailData();
    });
  }

  String? statusId;
  var detail = BookDetailData().obs;
  var doclist = <Document>[].obs;
  void _getDetailData() async {
    isLoading.value = true;
    var data = await api.bookDetailApiCall(widget.bookId);
    isLoading.value = false;
    if (data != null) {
      detail.value = data;
      // status.value = data.availableStatus!;
      doclist.value = data.documents!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: customText("Booking Detail", 14.sp, textColor: white),
        leading: IconButton(
            onPressed: () {
              Get.to(() => const AllBookingScreen());
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EditBooking(userId: detail.value));
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: SafeArea(
          child: Obx(
        () => isLoading.value
            ? Center(child: CupertinoActivityIndicator(radius: 20.r))
            : RefreshIndicator(
                onRefresh: () async {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    _getDetailData();
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 20.h),
                        decoration:
                            const BoxDecoration(color: Color(0xFFD8E0FF)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(detail.value.status.toString(), 14.sp,
                                textColor: kPrimaryColor,
                                fontWeight: FontWeight.w700),
                            SizedBox(height: 9.h),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12.r)),
                                            content: SizedBox(
                                              width: 300.w,
                                              height: 300.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                child: CachedNetworkImage(
                                                  imageUrl: detail
                                                      .value.userPhoto
                                                      .toString(),
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress,
                                                          color: kPrimaryColor),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Center(
                                                    child: Icon(Icons.error),
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    width: 120.w,
                                    height: 120.w,
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            width: 1,
                                            color: border.withOpacity(.5))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        width: 150.w,
                                        height: 150.w,
                                        imageUrl:
                                            detail.value.userPhoto.toString(),
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              color: kPrimaryColor),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                          "${detail.value.userName}", 17.sp,
                                          fontWeight: FontWeight.w600),
                                      SizedBox(height: 3.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.mail_outline,
                                              size: 18, color: kTextColor),
                                          SizedBox(width: 3.w),
                                          Flexible(
                                            child: Text(
                                              "${detail.value.userEmail}",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.phone,
                                              size: 18, color: kTextColor),
                                          SizedBox(width: 3.w),
                                          customText(
                                              '${detail.value.userMobile}',
                                              15.sp),
                                        ],
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.calendar_month,
                                              size: 18, color: kTextColor),
                                          SizedBox(width: 3.w),
                                          customText(
                                              "${detail.value.checkinDate}",
                                              14.sp),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // DropdownButtonFormField<String>(
                      //   isExpanded: true,
                      //   decoration: myInputDecoration(hintText: "Status"),
                      //   items: status
                      //       .map((value) => DropdownMenuItem<String>(
                      //           value: value.id.toString(),
                      //           child: Text(" ${value.name}")))
                      //       .toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       statusId = value!.toString();
                      //     });
                      //   },
                      //   value: statusId,
                      // ),
                      SizedBox(height: 20.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.map,
                                    color: kPrimaryColor, size: 35),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText("Propertys", 14.sp),
                                    SizedBox(height: 4.h),
                                    customText(
                                        "${detail.value.propertyName}", 15.sp,
                                        fontWeight: FontWeight.w700,
                                        maxLine: 3),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              child: Divider(
                                  height: 1,
                                  color: kPrimaryColor.withOpacity(.5)),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.bed,
                                    color: kPrimaryColor, size: 35),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText("Room", 14.sp),
                                    SizedBox(height: 4.h),
                                    customText(
                                        "${detail.value.roomName}", 15.sp,
                                        fontWeight: FontWeight.w700,
                                        maxLine: 3),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              child: Divider(
                                  height: 1,
                                  color: kPrimaryColor.withOpacity(.5)),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.bed,
                                    color: kPrimaryColor, size: 35),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                        "Booking For / Visit Purpose", 14.sp),
                                    SizedBox(height: 4.h),
                                    customText(
                                        "${detail.value.bookingFor} / ${detail.value.visitPurpose}",
                                        15.sp,
                                        fontWeight: FontWeight.w700),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              child: Divider(
                                  height: 1,
                                  color: kPrimaryColor.withOpacity(.5)),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.bed,
                                    color: kPrimaryColor, size: 35),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText("Booking Guest", 14.sp),
                                    SizedBox(height: 4.h),
                                    customText(
                                        "${detail.value.bookingForGuest}",
                                        15.sp,
                                        fontWeight: FontWeight.w700),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              child: Divider(
                                  height: 1,
                                  color: kPrimaryColor.withOpacity(.5)),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: kPrimaryColor, size: 35),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText("Check In", 14.sp),
                                    SizedBox(height: 4.h),
                                    customText(
                                        "${detail.value.checkinDate} | ${detail.value.checkinTime}",
                                        15.sp,
                                        fontWeight: FontWeight.w700),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              child: Divider(
                                  height: 1,
                                  color: kPrimaryColor.withOpacity(.5)),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: kPrimaryColor, size: 35),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText("Check Out", 14.sp),
                                    SizedBox(height: 4.h),
                                    customText(
                                        "${detail.value.checkoutDate} | ${detail.value.checkoutTime}",
                                        15.sp,
                                        fontWeight: FontWeight.w700),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              child: Divider(
                                  height: 1,
                                  color: kPrimaryColor.withOpacity(.5)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                  customText("Rent \nAmount", 14.sp,
                                      align: TextAlign.center, maxLine: 2),
                                  customText("${detail.value.rentAmount}", 22,
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
                                  customText("Food \nAmount", 14.sp,
                                      align: TextAlign.center, maxLine: 2),
                                  customText(
                                      "Rs.${detail.value.foodAmount}", 22,
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
                                  customText("Room \nNumber", 14.sp,
                                      align: TextAlign.center, maxLine: 2),
                                  customText("Rs.${detail.value.roomName}", 22,
                                      fontWeight: FontWeight.w800)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText("Documents", 14.sp,
                                fontWeight: FontWeight.w700),
                            SizedBox(height: 15.h),
                            SizedBox(
                              height: 155.w,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 12.w);
                                  },
                                  itemCount: doclist.length,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      width: 120.w,
                                      child: Column(
                                        children: [
                                          customText(
                                              "${doclist[index].name}", 14.sp,
                                              fontWeight: FontWeight.w800),
                                          SizedBox(height: 12.h),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              width: 120.w,
                                              height: 120.w,
                                              imageUrl: doclist[index].url!,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress,
                                                        color: kPrimaryColor),
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.photo,
                                                size: 22.w,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      )),
    );
  }
}
