import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/employee/employeedetail_modal.dart';
import 'package:ongcguest_house/pages/employee/edit_employee.dart';

class EmployeeDetail extends StatefulWidget {
  final String employeeId;
  const EmployeeDetail({super.key, required this.employeeId});

  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  RxBool isLoading = true.obs;
  bool isLoadingMore = false;
  @override
  void initState() {
    super.initState();
    _getemployeeDetail();
  }

  var empdoclist = <Document>[].obs;
  var empDetail = EmployeeDetailData().obs;
  void _getemployeeDetail() async {
    isLoading.value = true;
    var result = await api.allemployeeDetailApiCall(widget.employeeId);
    isLoading.value = false;
    if (result != null) {
      empDetail.value = result;
      empdoclist.value = result.documents!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: customText("Employee Detail", 14.sp, textColor: white),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EditEmployee(empDetail: empDetail.value));
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: SafeArea(
          child: Obx(
        () => isLoading.value
            ? Center(child: CupertinoActivityIndicator(radius: 20.r))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 20.h),
                      decoration: const BoxDecoration(color: Color(0xFFD8E0FF)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                                  BorderRadius.circular(12.r)),
                                          content: SizedBox(
                                            width: 300.w,
                                            height: 300.w,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                              child: CachedNetworkImage(
                                                imageUrl: empDetail
                                                    .value.userPhoto
                                                    .toString(),
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress,
                                                            color:
                                                                kPrimaryColor),
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
                                  width: 110.w,
                                  height: 110.w,
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
                                          empDetail.value.userPhoto.toString(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                        "${empDetail.value.userName!.capitalize}",
                                        17.sp,
                                        fontWeight: FontWeight.w700),
                                    SizedBox(height: 7.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.mail_outline,
                                            size: 18, color: kTextColor),
                                        SizedBox(width: 3.w),
                                        Flexible(
                                          child: Text(
                                            "${empDetail.value.userEmail}",
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 7.h),
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
                                            '${empDetail.value.userMobile} / ${empDetail.value.altContact}',
                                            15.sp),
                                      ],
                                    ),
                                    SizedBox(height: 5.h),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  color: kPrimaryColor, size: 35),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText("Address", 14.sp),
                                  SizedBox(height: 4.h),
                                  customText(
                                      "${empDetail.value.address}, ${empDetail.value.city}, ${empDetail.value.state}, ${empDetail.value.country}",
                                      15.sp,
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
                              const Icon(Icons.business,
                                  color: kPrimaryColor, size: 35),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText("Company", 14.sp),
                                  SizedBox(height: 4.h),
                                  customText(
                                      "${empDetail.value.userCompany}", 15.sp,
                                      fontWeight: FontWeight.w700, maxLine: 3),
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
                              const Icon(Icons.fastfood_rounded,
                                  color: kPrimaryColor, size: 35),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText("Food Complementary", 14.sp),
                                  SizedBox(height: 4.h),
                                  empDetail.value.foodComplementary == 0
                                      ? customText("Personal", 15.sp,
                                          fontWeight: FontWeight.w700,
                                          maxLine: 3)
                                      : customText("Official", 15.sp,
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
                          empdoclist.length.isEqual(0)
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 20.h, left: 18.w),
                                  child: Text(
                                    "No Data",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontStyle: FontStyle.italic),
                                  ),
                                )
                              : SizedBox(
                                  height: 200.h,
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(width: 20.w);
                                      },
                                      itemCount: empdoclist.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.r)),
                                                        content: SizedBox(
                                                          width: 300.w,
                                                          height: 300.w,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.r),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  empdoclist[
                                                                          index]
                                                                      .url
                                                                      .toString(),
                                                              progressIndicatorBuilder: (context,
                                                                      url,
                                                                      downloadProgress) =>
                                                                  CircularProgressIndicator(
                                                                      value: downloadProgress
                                                                          .progress,
                                                                      color:
                                                                          kPrimaryColor),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Center(
                                                                child: Icon(
                                                                    Icons
                                                                        .error),
                                                              ),
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  width: 120.w,
                                                  height: 120.w,
                                                  imageUrl: empdoclist[index]
                                                      .url
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
                                                          const Center(
                                                    child: Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 12.h),
                                            customText(
                                                "${empdoclist[index].name}",
                                                14.sp,
                                                fontWeight: FontWeight.w800),
                                          ],
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
      )),
    );
  }
}
