import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/checkin_booking_modal.dart';
import 'package:ongcguest_house/pages/my_drawer.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({super.key});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkInScreen();
      scrollController.addListener(_scrollListener);
    });
  }

  int page = 1;
  RxBool isLoading = true.obs;
  final scrollController = ScrollController();

  var checkIn = <CheckinBookingData>[].obs;
  void _checkInScreen() async {
    isLoading.value = true;
    var result = await api.checkinbookingApiCall(page);
    isLoading.value = false;
    if (result != null) {
      checkIn.value = result;
    }
  }

  bool isLoadingMore = false;
  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      _checkInScreen();
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: customText("Check In", 16.sp, textColor: white),
        ),
        drawer: const MyDrawer(),
        body: Obx(
          () => isLoading.value
              ? Center(child: CupertinoActivityIndicator(radius: 20.r))
              : RefreshIndicator(
                  onRefresh: () async {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      _checkInScreen();
                    });
                  },
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15.h);
                      },
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      itemCount:
                          isLoadingMore ? checkIn.length + 1 : checkIn.length,
                      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //     childAspectRatio: .95,
                      //     crossAxisSpacing: 15,
                      //     mainAxisSpacing: 15,
                      //     crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        if (index < checkIn.length) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 2.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.122),
                                      blurRadius: 3.0,
                                      spreadRadius: 1),
                                ],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 2.h),
                                    decoration: const BoxDecoration(
                                        color: kPrimaryColor),
                                    child: customText(
                                      "${checkIn[index].status}",
                                      14.sp,
                                      textColor: white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
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
                                          "${checkIn[index].checkin}", 14.sp),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      checkIn[index].userPhoto!.isNotEmpty
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
                                                  imageUrl: checkIn[index]
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
                                                        "${checkIn[index].name![0].capitalize}",
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
                                                    "${checkIn[index].name}",
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
                                                    "${checkIn[index].userEmail}",
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
                                                    "${checkIn[index].userMobile}",
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
                                                    "${checkIn[index].userEmployeeId}",
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
                                            "${checkIn[index].companyName}",
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
                                            "${checkIn[index].property}", 14.sp,
                                            maxLine: 3),
                                      ),
                                      const Icon(Icons.bed,
                                          color: kPrimaryColor, size: 20),
                                      SizedBox(width: 5.w),
                                      customText(
                                          "${checkIn[index].room}", 14.sp),
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
                                          "${checkIn[index].checkout}", 14.sp),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
        ));
  }
}
