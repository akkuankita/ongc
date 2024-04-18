import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/bottombar/mytab_bar.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/all_booking_modal.dart';
import 'package:ongcguest_house/pages/booking_detail.dart';

class AllBookingScreen extends StatefulWidget {
  const AllBookingScreen({super.key});

  @override
  State<AllBookingScreen> createState() => _AllBookingScreenState();
}

class _AllBookingScreenState extends State<AllBookingScreen> {
  int page = 1;
  RxBool isLoading = true.obs;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _allbookingScreen();
      scrollController.addListener(_scrollListener);
    });
  }

  var allbooklist = <AllBookingData>[].obs;
  void _allbookingScreen() async {
    isLoading.value = true;
    var result = await api.allBookingApiCall(page);
    isLoading.value = false;
    if (result != null) {
      allbooklist.addAll(result);
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
      _allbookingScreen();
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
          title: customText("All Booking", 14.sp, textColor: white),
          leading: IconButton(
              onPressed: () {
                Get.to(() => const MyTabBar());
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Obx(
          () => isLoading.value
              ? Center(child: CupertinoActivityIndicator(radius: 20.r))
              : RefreshIndicator(
                  onRefresh: () async {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      _allbookingScreen();
                    });
                  },
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 15.h);
                      },
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      itemCount: isLoadingMore
                          ? allbooklist.length + 1
                          : allbooklist.length,
                      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //     childAspectRatio: .95,
                      //     crossAxisSpacing: 15,
                      //     mainAxisSpacing: 15,
                      //     crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        if (index < allbooklist.length) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => BookingDetail(
                                  bookId: allbooklist[index].id.toString()));
                            },
                            child: Container(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 16.w, vertical: 12.h),
                              // decoration: BoxDecoration(
                              //   color: index % 2 == 0
                              //       ? white
                              //       : const Color(0xFFE7E7E7).withOpacity(.4),
                              // ),
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
                                      "${allbooklist[index].status}",
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
                                          "${allbooklist[index].checkin}",
                                          14.sp),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      allbooklist[index].userPhoto!.isNotEmpty
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
                                                  imageUrl: allbooklist[index]
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
                                                        "${allbooklist[index].name![0].capitalize}",
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
                                                    "${allbooklist[index].name}",
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
                                                    "${allbooklist[index].userEmail}",
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
                                                    "${allbooklist[index].userMobile}",
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
                                                    "${allbooklist[index].userEmployeeId}",
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
                                            "${allbooklist[index].companyName}",
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
                                            "${allbooklist[index].property}",
                                            14.sp,
                                            maxLine: 3),
                                      ),
                                      const Icon(Icons.bed,
                                          color: kPrimaryColor, size: 20),
                                      SizedBox(width: 5.w),
                                      customText(
                                          "${allbooklist[index].room}", 14.sp),
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
                                          "${allbooklist[index].checkout}",
                                          14.sp),
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
