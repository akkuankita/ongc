import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/employee/allemployeelist_modal.dart';
import 'package:ongcguest_house/pages/employee/employee_detail.dart';

class SearchEmployee extends StatefulWidget {
  const SearchEmployee({super.key});

  @override
  State<SearchEmployee> createState() => _SearchEmployeeState();
}

class _SearchEmployeeState extends State<SearchEmployee> {
  RxBool isLoading = true.obs;
  final scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(_scrollListener);
    });
  }

  var semployeelist = <AllEmployeeListData>[].obs;
  void _getemployeesearch() async {
    isLoading.value = true;
    var result = await api.searchlemployeeApiCall(_name.text, page);
    isLoading.value = false;
    if (result != null) {
      semployeelist.addAll(result);
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
      _getemployeesearch();
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
          automaticallyImplyLeading: false,
          title: customText("Search Employee", 14.sp, textColor: white),
          actions: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close))
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w, top: 15.h, right: 16.w),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _name,
                    decoration: myInputDecoration(hintText: "Booked By Search"),
                    onChanged: (text) {
                      if (text.trim().length == 4) {
                        _getemployeesearch();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 19.h),
              Obx(() {
                return Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 12.h);
                      },
                      //  shrinkWrap: true,
                      controller: scrollController,
                      itemCount: isLoadingMore
                          ? semployeelist.length + 1
                          : semployeelist.length,
                      itemBuilder: (context, index) {
                        if (index < semployeelist.length) {
                          return InkWell(
                            onTap: () {
                              Get.to(() => EmployeeDetail(
                                  employeeId:
                                      semployeelist[index].id.toString()));
                              // Get.to(() => EmployeeDetail(
                              //     employeeId: guestnamelist[index].id));
                              // widget.categoryTitle!.contains("employee")
                              //     ? Get.to(() => EmployeeScreen(
                              //         guestId:
                              //             guestnamelist[index].id.toString(),
                              //         guestname:
                              //             guestnamelist[index].name.toString()))
                              //     : Get.to(() => AddBookingScreen(
                              //         guestId:
                              //             guestnamelist[index].id.toString(),
                              //         guestname: guestnamelist[index]
                              //             .name
                              //             .toString()));
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                bottom:
                                    BorderSide(color: kTextColor, width: .5),
                              )),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              child: Text(semployeelist[index].userName!),
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
        ));
  }
}
