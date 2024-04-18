import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/employee_list_modal.dart';
import 'package:ongcguest_house/network/modal/guest_name_list.dart';
import 'package:ongcguest_house/pages/searchguest_list.dart';
import 'package:ongcguest_house/pages/my_drawer.dart';

class EmployeeScreen extends StatefulWidget {
  final String guestId, guestname;
  const EmployeeScreen(
      {super.key, required this.guestId, required this.guestname});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  RxBool isLoading = true.obs;
  bool isLoadingMore = false;
  final scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _checkIndate = TextEditingController();
  final _checkOutdate = TextEditingController();
  final _name = TextEditingController();
  var emplist = <EmployeeData>[].obs;
  var guestnamelist = <GuestSearchData>[].obs;

  @override
  void initState() {
    super.initState();
    _checkIndate.text = DateTime.now().toString();
    _checkOutdate.text = DateTime.now().add(const Duration(days: 7)).toString();
    _name.text = widget.guestname;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _employee();
      scrollController.addListener(_scrollListener);
    });
  }

  void _employee() async {
    var result = await api.employeeApiCall(
        _checkIndate.text, _checkOutdate.text, widget.guestId, page);
    if (result != null) {
      emplist.addAll(result);
      // emplist.value = result;
    }
  }

  int page = 1;
  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      _employee();
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
        title: customText("Employee", 14.sp, textColor: white),
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 15.h, right: 16.w),
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
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xFFF5F7F9)),
                                child: TextFormField(
                                  controller: _checkIndate,
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
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1200),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      String datetime1 =
                                          DateFormat("yyyy-MM-dd")
                                              .format(pickedDate);
                                      _checkIndate.text = datetime1;
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
                                  controller: _checkOutdate,
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
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1200),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      String datetime1 =
                                          DateFormat("yyyy-MM-dd")
                                              .format(pickedDate);
                                      _checkOutdate.text = datetime1;
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
                        SizedBox(height: 10.h),
                        // InkWell(
                        //   onTap: () {

                        //   },
                        //   child: Text("data"),
                        // ),
                        InkWell(
                          onTap: () {
                            Get.to(() => const SearchGuestList(
                                categoryTitle: "employee"));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15.h),
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                    width: 1, color: const Color(0xFFCCCCCC))),
                            child: Row(
                              children: [
                                widget.guestname.isEmpty
                                    ? Text(
                                        "Search Guest",
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(.7),
                                            fontSize: 14.sp,
                                            fontFamily: "OpenSansRegular"),
                                      )
                                    : Text(
                                        widget.guestname,
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
                        // TextFormField(
                        //   readOnly: true,
                        //   controller: _name,
                        //   decoration: myInputDecoration(
                        //       hintText: "Booked By Search",
                        //       suffixIcon: IconButton(
                        //           onPressed: () {
                        //             Get.to(() => const SearchGuestList(
                        //                 categoryTitle: "employee"));
                        //           },
                        //           icon: const Icon(Icons.search))),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  InkWell(
                    onTap: () {
                      _employee();
                    },
                    child: Container(
                      width: 42.w,
                      height: 109.w,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(4.r)),
                      child: const Icon(Icons.search, color: white, size: 22),
                    ),
                  )
                ],
              ),
            ),
          ),
          Obx(() {
            return Expanded(
              child: emplist.length.isEqual(0)
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
                      itemCount:
                          isLoadingMore ? emplist.length + 1 : emplist.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < emplist.length) {
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
                                  children: [
                                    customText("Check In", 14.sp,
                                        fontWeight: FontWeight.w800,
                                        textColor: kPrimaryColor),
                                    SizedBox(width: 5.w),
                                    customText(
                                        "${emplist[index].checkin}", 14.sp),
                                    const Spacer(),
                                    customText(
                                      "${emplist[index].bookFor}",
                                      14.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    emplist[index].userPhoto!.isNotEmpty
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
                                                imageUrl: emplist[index]
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
                                                          color: kPrimaryColor),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Center(
                                                  child: customText(
                                                      "${emplist[index].name![0].capitalize}",
                                                      22.sp,
                                                      textColor: kPrimaryColor,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.person,
                                                  color: kPrimaryColor,
                                                  size: 20),
                                              SizedBox(width: 5.w),
                                              Flexible(
                                                child: Text(
                                                    "${emplist[index].name}",
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: kTextColor)),
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
                                                  "${emplist[index].userEmail}",
                                                  maxLines: 2,
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
                                                  "${emplist[index].userMobile}",
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
                                                  "${emplist[index].userEmployeeId}",
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.business,
                                        color: kPrimaryColor, size: 20),
                                    SizedBox(width: 5.w),
                                    Expanded(
                                      child: customText(
                                          "${emplist[index].companyName}",
                                          14.sp,
                                          maxLine: 3),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.map,
                                        color: kPrimaryColor, size: 20),
                                    SizedBox(width: 5.w),
                                    Expanded(
                                      child: customText(
                                          "${emplist[index].property}", 14.sp,
                                          maxLine: 3),
                                    ),
                                    const Icon(Icons.bed,
                                        color: kPrimaryColor, size: 20),
                                    SizedBox(width: 5.w),
                                    customText("${emplist[index].room}", 14.sp),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customText("Rent :", 14.sp,
                                        fontWeight: FontWeight.w800),
                                    SizedBox(width: 5.w),
                                    customText(
                                        "Rs. ${emplist[index].rentAmount}",
                                        14.sp),
                                    const Spacer(),
                                    customText("Food :", 14.sp,
                                        fontWeight: FontWeight.w800),
                                    SizedBox(width: 5.w),
                                    customText(
                                        "Rs. ${emplist[index].foodAmount}",
                                        14.sp),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                customText("Check Out", 14.sp,
                                    fontWeight: FontWeight.w800,
                                    textColor: red),
                                SizedBox(width: 5.w),
                                customText("${emplist[index].checkout}", 14.sp),
                                SizedBox(height: 8.h),
                                customText(
                                  "${emplist[index].status}",
                                  14.sp,
                                  textColor:
                                      emplist[index].status == "Checked Out"
                                          ? kPrimaryColor
                                          : red,
                                  fontWeight: FontWeight.w800,
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
      )),
    );
  }
}
