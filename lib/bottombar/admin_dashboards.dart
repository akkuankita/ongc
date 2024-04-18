import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/login/login_screen.dart';
import 'package:ongcguest_house/my_sharepref.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/home_screen_modal.dart';
import 'package:ongcguest_house/pages/my_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdminDashboards extends StatefulWidget {
  const AdminDashboards({super.key});

  @override
  State<AdminDashboards> createState() => _AdminDashboardsState();
}

class _AdminDashboardsState extends State<AdminDashboards> {
  RxBool isLoading = true.obs;
  final _formKey = GlobalKey<FormState>();
  final _checkIndate = TextEditingController();
  final _checkOutdate = TextEditingController();

  var pro = <HomeData>[].obs;

  @override
  void initState() {
    super.initState();
    _checkIndate.text = DateTime.now().toString();
    _checkOutdate.text = DateTime.now().add(const Duration(days: 7)).toString();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _dashboard();
    });
  }

  void _dashboard() async {
    var result = await api.dashboardApiCall(
        checkIndate: _checkIndate.text, checkOutdate: _checkOutdate.text);
    if (result != null) {
      pro.value = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          //title: customText("Admin", 14.sp, textColor: white),
          title: Image.asset("assets/images/logo.jpeg", width: 45.w),
          actions: [
            // IconButton(
            //     onPressed: () {
            //       Get.to(() => ExcelDownloader());
            //     },
            //     icon: Container(
            //         padding:
            //             EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            //         decoration: BoxDecoration(
            //             color: white,
            //             borderRadius: BorderRadius.circular(50.r)),
            //         child: const Icon(Icons.person, color: kPrimaryColor))),
            IconButton(
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Log Out'),
                      content: Padding(
                        padding:
                            EdgeInsets.only(left: 20.w, right: 16.w, top: 15.h),
                        child: const Text('Are you sure you want to Log out ?'),
                      ),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: red,
                          ),
                          child: const Text("Yes"),
                          onPressed: () => {
                            sharedPref.clear(),
                            Get.offAll(() => const LoginScreen())
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                          ),
                          child: const Text("No"),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                  );
                },
                icon: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(50.r)),
                    child:
                        const Icon(Icons.logout_rounded, color: kPrimaryColor)))
          ],
        ),
        drawer: const MyDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 15.h, right: 16.w),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Color(0xFFF5F7F9)),
                            child: TextFormField(
                              controller: _checkIndate,
                              readOnly: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(top: 15.h, left: 12.w),
                                  hintText: "",
                                  suffixIcon: const Icon(Icons.calendar_month,
                                      size: 20, color: kTextColor)),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now()
                                      .add(const Duration(days: 0)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  String datetime1 = DateFormat("yyyy-MM-dd")
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
                            decoration:
                                const BoxDecoration(color: Color(0xFFF5F7F9)),
                            child: TextFormField(
                              readOnly: true,
                              controller: _checkOutdate,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(top: 15.h, left: 12.w),
                                  hintText: "",
                                  suffixIcon: const Icon(Icons.calendar_month,
                                      size: 20, color: kTextColor)),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now()
                                      .add(const Duration(days: 0)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  String datetime1 = DateFormat("yyyy-MM-dd")
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
                        SizedBox(width: 10.w),
                        InkWell(
                          onTap: () {
                            _dashboard();
                          },
                          child: Container(
                            width: 42.w,
                            height: 42.w,
                            decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(4.r)),
                            child: const Icon(Icons.search,
                                color: white, size: 22),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      itemCount: pro.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: .94,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 1.sw,
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 8.h),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4.0,
                                    spreadRadius: 2),
                              ],
                              borderRadius: BorderRadius.circular(4.r),
                              color: white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  pro[index].propertyImage!.isNotEmpty
                                      ? CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          height: 100.h,
                                          width: 1.sw,
                                          imageUrl: pro[index]
                                              .propertyImage
                                              .toString(),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                color: kPrimaryColor),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: customText("No Image", 22.sp,
                                                textColor: kPrimaryColor,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        )
                                      : Center(
                                          child: customText("No Image", 22.sp,
                                              textColor: kPrimaryColor,
                                              fontWeight: FontWeight.w800),
                                        ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8.w,
                                          right: 8.w,
                                          top: 4.h,
                                          bottom: 4.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          color: red),
                                      child: customText(
                                          "Total Occupied : ${pro[index].occupied}",
                                          14.sp,
                                          textColor: white),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              customText(
                                  "Total Room: ${pro[index].totalRoom}", 14.sp,
                                  fontWeight: FontWeight.w500),
                              SizedBox(height: 4.h),
                              Text(
                                pro[index].propertyName.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14.sp, color: kTextColor),
                              ),
                              SizedBox(height: 4.h),
                              customText(
                                  pro[index].propertyCity.toString(), 14.sp),
                            ],
                          ),
                        );
                      });
                }),
              ],
            ),
          ),
        ));
  }
}
