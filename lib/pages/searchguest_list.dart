import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/network/api.dart';
import 'package:ongcguest_house/network/modal/guest_name_list.dart';
import 'package:ongcguest_house/pages/addbooking_screen.dart';
import 'package:ongcguest_house/pages/reports/employee_screen.dart';

class SearchGuestList extends StatefulWidget {
  final String? categoryTitle;
  const SearchGuestList({super.key, this.categoryTitle});

  @override
  State<SearchGuestList> createState() => _SearchGuestListState();
}

class _SearchGuestListState extends State<SearchGuestList> {
  RxBool isLoading = true.obs;
  final scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();

  var guestnamelist = <GuestItem>[].obs;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  void _guestlist() async {
    isLoading.value = true;
    var result = await api.guestsearchApiCall(_name.text, page);
    isLoading.value = false;
    if (result != null) {
      guestnamelist.addAll(result.items!);
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
      _guestlist();
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
          title: customText("Guest list", 14.sp, textColor: white),
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
                        _guestlist();
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
                          ? guestnamelist.length + 1
                          : guestnamelist.length,
                      itemBuilder: (context, index) {
                        if (index < guestnamelist.length) {
                          return InkWell(
                            onTap: () {
                              widget.categoryTitle!.contains("employee")
                                  ? Get.to(() => EmployeeScreen(
                                      guestId:
                                          guestnamelist[index].id.toString(),
                                      guestname:
                                          guestnamelist[index].name.toString()))
                                  : Get.to(() => AddBookingScreen(
                                      guestId:
                                          guestnamelist[index].id.toString(),
                                      guestname: guestnamelist[index]
                                          .name
                                          .toString()));
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                bottom:
                                    BorderSide(color: kTextColor, width: .5),
                              )),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              child: Text(guestnamelist[index].name.toString()),
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
