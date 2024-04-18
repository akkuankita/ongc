import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/book_list_modal.dart';
import 'package:ongcguest_house/pages/addbooking_screen.dart';
import 'package:ongcguest_house/pages/my_drawer.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final scrollController = ScrollController();
  var booklist = <BookListData>[].obs;
  RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bookingScreen();
      scrollController.addListener(_scrollListener);
    });
  }

  void _bookingScreen() async {
    isLoading.value = true;
    var result = await api.fetchbooklist(page);
    isLoading.value = false;
    if (result != null) {
      booklist.addAll(result);
    }
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
      _bookingScreen();
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
          title: customText("Latest Booking", 14.sp, textColor: white),
        ),
        drawer: const MyDrawer(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          child: DefaultButton(
              text: "Add Booking",
              press: () {
                Get.to(() => const AddBookingScreen(
                      guestId: "",
                      guestname: "",
                    ));
              }),
        ),
        body: Obx(
          () => isLoading.value
              ? Center(child: CupertinoActivityIndicator(radius: 20.r))
              : RefreshIndicator(
                  onRefresh: () async {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      _bookingScreen();
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
                          isLoadingMore ? booklist.length + 1 : booklist.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < booklist.length) {
                          return Container(
                            // width: 1.sw,
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: 16.w, vertical: 12.h),
                            // decoration: BoxDecoration(
                            //   color: index % 2 == 0
                            //       ? const Color(0xFFE7E7E7).withOpacity(.8)
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
                                Row(
                                  children: [
                                    const Icon(Icons.calculate_outlined,
                                        color: green, size: 20),
                                    SizedBox(width: 5.w),
                                    customText(
                                        "Check In : ${booklist[index].checkin}",
                                        14.sp,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    customText("Name :", 14.sp,
                                        fontWeight: FontWeight.w800),
                                    SizedBox(width: 5.w),
                                    customText("${booklist[index].name}", 14.sp,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    customText("Company Name :", 14.sp,
                                        fontWeight: FontWeight.w800),
                                    SizedBox(width: 5.w),
                                    customText(
                                        "${booklist[index].companyName}", 14.sp,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    customText("Property Name :", 14.sp,
                                        fontWeight: FontWeight.w800),
                                    SizedBox(width: 5.w),
                                    Flexible(
                                      child: customText(
                                          "${booklist[index].property}", 14.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    customText("Room :", 14.sp,
                                        fontWeight: FontWeight.w800),
                                    SizedBox(width: 5.w),
                                    customText(
                                        "Total Room: ${booklist[index].room}",
                                        14.sp,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calculate_outlined,
                                      color: red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5.w),
                                    customText(
                                        "Check Out : ${booklist[index].checkout}",
                                        14.sp,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ],
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
