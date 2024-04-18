import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/bottombar/mytab_bar.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/employee/allemployeelist_modal.dart';
import 'package:ongcguest_house/pages/employee/add_employee.dart';
import 'package:ongcguest_house/pages/employee/employee_detail.dart';
import 'package:ongcguest_house/pages/employee/search_employee.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  int page = 1;
  RxBool isLoading = true.obs;
  // final scrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getemployeelistScreen();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        _getemployeelistScreen();
      }
    });
    //scrollController.addListener(_scrollListener);
  }

  var allemployeelist = <AllEmployeeListData>[].obs;
  void _getemployeelistScreen() async {
    isLoading.value = true;
    var result = await api.allemployeeApiCall(page);
    isLoading.value = false;
    if (result != null) {
      allemployeelist.addAll(result);
    }
  }

  bool isLoadingMore = false;
  // Future<void> _scrollListener() async {
  //   if (isLoadingMore) return;
  //   if (scrollController.position.pixels ==
  //       scrollController.position.maxScrollExtent) {
  //     // setState(() {
  //     //   isLoadingMore = true;
  //     // });
  //     page++;
  //     _getemployeelistScreen();
  //     // setState(() {
  //     //   isLoadingMore = false;
  //     // });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: customText("Employee List", 14.sp, textColor: white),
        leading: IconButton(
            onPressed: () {
              Get.to(() => const MyTabBar());
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        child: DefaultButton(
            text: "Add Employee",
            press: () {
              Get.to(() => const AddEmployee());
            }),
      ),
      body: Obx(
        () => isLoading.value
            ? Center(child: CupertinoActivityIndicator(radius: 20.r))
            : Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => const SearchEmployee());
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 15.h),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                              width: 1, color: const Color(0xFFCCCCCC))),
                      child: Row(
                        children: [
                          Text(
                            "Search ....",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "OpenSansRegular"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15.h);
                        },
                        // itemCount: isLoadingMore
                        //     ? allemployeelist.length + 1
                        //     : allemployeelist.length,
                        itemCount: allemployeelist.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => EmployeeDetail(
                                  employeeId:
                                      allemployeelist[index].id.toString(),
                                ),
                              );
                            },
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
                              child: Row(
                                children: [
                                  allemployeelist[index].userPhoto!.isNotEmpty
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
                                                  color:
                                                      border.withOpacity(.5))),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              width: 90.w,
                                              height: 90.w,
                                              imageUrl: allemployeelist[index]
                                                  .userPhoto
                                                  .toString(),
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
                                                  (context, url, error) =>
                                                      ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.asset(
                                                    "assets/images/pro.jpg",
                                                    fit: BoxFit.cover,
                                                    width: 90.w,
                                                    height: 90.w),
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
                                                  color:
                                                      border.withOpacity(.5))),
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
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.person,
                                                color: kPrimaryColor, size: 20),
                                            SizedBox(width: 5.w),
                                            customText(
                                                allemployeelist[index]
                                                    .userName!
                                                    .capitalize
                                                    .toString(),
                                                14.sp,
                                                fontWeight: FontWeight.w700,
                                                maxLine: 2),
                                          ],
                                        ),
                                        SizedBox(height: 3.h),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.mail,
                                                color: kPrimaryColor, size: 20),
                                            SizedBox(width: 5.w),
                                            Flexible(
                                              child: customText(
                                                  allemployeelist[index]
                                                      .userEmail!,
                                                  14.sp,
                                                  maxLine: 2),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 3.h),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.phone,
                                                color: kPrimaryColor, size: 20),
                                            SizedBox(width: 5.w),
                                            customText(
                                                allemployeelist[index]
                                                    .userMobile!,
                                                14.sp),
                                          ],
                                        ),
                                        SizedBox(height: 3.h),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.business,
                                                color: kPrimaryColor, size: 20),
                                            SizedBox(width: 5.w),
                                            customText(
                                                allemployeelist[index]
                                                    .userCompany!,
                                                14.sp),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
      ),
    );
  }
}
