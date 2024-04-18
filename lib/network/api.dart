// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:ongcguest_house/constants.dart';
import 'package:ongcguest_house/my_sharepref.dart';
import 'package:ongcguest_house/network/modal/advancedbooking_modal.dart';
import 'package:ongcguest_house/network/modal/all_booking_modal.dart';
import 'package:ongcguest_house/network/modal/available_rooms_modal.dart';
import 'package:ongcguest_house/network/modal/book_detail_modal.dart';
import 'package:ongcguest_house/network/modal/book_list_modal.dart';
import 'package:ongcguest_house/network/modal/checkin_booking_modal.dart';
import 'package:ongcguest_house/network/modal/employee/allemployeelist_modal.dart';
import 'package:ongcguest_house/network/modal/employee/companylist_modal.dart';
import 'package:ongcguest_house/network/modal/employee/countrylist_modal.dart';
import 'package:ongcguest_house/network/modal/employee/employeedetail_modal.dart';
import 'package:ongcguest_house/network/modal/employee/statelist_modal.dart';
import 'package:ongcguest_house/network/modal/employee_list_modal.dart';
import 'package:ongcguest_house/network/modal/guest_name_list.dart';
import 'package:ongcguest_house/network/modal/home_screen_modal.dart';
import 'package:ongcguest_house/network/modal/paymentwise_export_modal.dart';
import 'package:ongcguest_house/network/modal/property_list_modal.dart';
import 'package:ongcguest_house/network/modal/property_wise_modal.dart';
import 'package:ongcguest_house/network/modal/room_list_modal.dart';
import 'package:ongcguest_house/network/modal/payment_summary_modal.dart';

final Api api = Get.find();

class Api extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    //http://13.201.209.141/api/v1/user/login
    httpClient.baseUrl = 'http://13.201.209.141/api/v1/';
    httpClient.timeout = const Duration(seconds: 60);
  }

  getHeader() => {
        // 'Authorization': "Bearer $token",
        'Authorization': "Bearer ${sharedPref.getToken()}",
      };
  final String loginUrl = 'user/login';
  final String dashboardUrl = 'dashboard/roomStatus';
  // final String profileUrl = 'user/profile';
  final String booklistUrl = 'dashboard/latestBookings?page=';
  final String employeeUrl = 'report/employeeWise?page=';
  final String guestsearchUrl = 'global/guestSearch?q=a&page=1';
  final String propertylistsUrl = 'global/propertyLists';
  final String roomOccupancyUrl = 'report/payment_together?page=';
  // final String paymentsummaryUrl = 'report/payment';
  final String propertyWiserepUrl = 'report/propertyWise?page=';
  final String roomlistsUrl = 'global/roomLists?property_id=';
  final String availableRoomsUrl = 'booking/availableRooms';
  final String bookingcreateUrl = 'booking/create';
  final String paymentwiseExportUrl = 'report/paymentWiseExport';
  final String allBokkingUrl = 'booking/lists?page=';
  final String bookDetailUrl = 'booking/details/';
  final String updateUrl = 'booking/update/';
  final String advancedbookingUrl = 'booking/advancedBookingLists?page=';
  final String checkinbookingUrl = 'booking/checkinBookingLists?page=';
  final String allemployeesUrl = 'employees/lists';
  final String allemployeeDetailUrl = 'employees/details/';
  final String companyListsUrl = 'global/companyLists';
  final String countryUrl = 'global/countryLists';
  final String stateUrl = 'global/stateLists/';
  final String createempUrl = 'employees/create';
  final String editempUrl = 'employees/update/';
// -------------------------------Booking Detail-------------------------- ------------

  Future<BookDetailData?> bookDetailApiCall(String bookId) async {
    final response = await get(bookDetailUrl + bookId, headers: getHeader());
    //print(response.request?.url);

    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myresponse = BookDetailModal.fromJson(myjson);
      if (myresponse.status == true) {
        return myresponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// -------------------------------report-------------------------- ------------

  Future<PaymentWiseExportData?> paymentwiseExportApiCall(
      {String? formdate, String? todate, String? property}) async {
    final body = {
      'fromDate': formdate,
      'toDate': todate,
      'property': property,
    };
    showProgress();
    final response =
        await post(paymentwiseExportUrl, body, headers: getHeader());
    hideProgress();
    print(response.body);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      var myResponse = PaymentWiseExportModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// -------------------propertyWise ------------

  Future<List<PropertyWiseData>?> propertyWiserepApiCall(String? propertyId,
      String? roomId, String? fromDate, String? todate, page) async {
    final body = {
      'fromDate': fromDate,
      'toDate': todate,
      'property': propertyId,
      'room': roomId,
    };
    showProgress();
    final response =
        await post(propertyWiserepUrl + page, body, headers: getHeader());
    hideProgress();
    // print(response.request?.url);
    // print(response.body);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      var myResponse = PropertyWiseModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// -------------------paymentsummaryUrl ------------

  // Future<PaymentsummaryData?> paymentsummaryApiCall(
  //     {String? formdate, String? todate, String? property}) async {
  //   final body = {'fromDate': formdate, 'toDate': todate, 'property': property};
  //   showProgress();
  //   final response = await post(paymentsummaryUrl, body, headers: getHeader());
  //   hideProgress();
  //   // print(response.request?.url);
  //   //  print(response.body);
  //   if (response.isOk) {
  //     final myjson = jsonDecode(response.body);
  //     var myResponse = PaymentsummaryModal.fromJson(myjson);
  //     if (myResponse.status == true) {
  //       return myResponse.data;
  //     } else {
  //       showToast(myjson['message']);
  //     }
  //   }
  //   return null;
  // }

// -------------------roomOccupancyUrl------------

  Future<PaymentSummaryData?> roomOccupancyApiCall(
      {String? formdate, String? todate, String? property, page}) async {
    final body = {
      'fromDate': formdate,
      'toDate': todate,
      'property': property,
    };
    showProgress();
    final response = await post(roomOccupancyUrl + page.toString(), body,
        headers: getHeader());
    hideProgress();
    print(response.request?.url);
    // print(response.body);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      var myResponse = PaymentSummaryModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// ------------------------login---------------

  Future<bool> loginApiCall({String? email, String? password}) async {
    final body = {'email': email, 'password': password};
    showProgress();
    final response = await post(loginUrl, body);
    hideProgress();
    //  print(response.body);

    if (response.isOk) {
      var myjson = jsonDecode(response.body);
      if (myjson['status'] == true) {
        // sharedPref.setLogin(true);
        // sharedPref.setToken("token");
        // sharedPref.setLogin(true);
        sharedPref.saveLoginData(myjson['data']);
        showToast(myjson['message'] ?? '', color: green);
        return true;
      }
    }
    return false;
  }

// ------------------------ dashboard---------------

  Future<List<HomeData>?> dashboardApiCall(
      {String? checkIndate, String? checkOutdate}) async {
    final body = {'fromDate': checkIndate, 'toDate': checkOutdate};
    showProgress();
    final response = await post(dashboardUrl, body, headers: getHeader());
    hideProgress();

    /// print(response.body);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      var myResponse = HomeScreenModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// // ------------------------ profile---------------
//   Future<ProfileData?> fetchprofile() async {
//     showProgress();
//     final response = await get(profileUrl, headers: getHeader());
//     hideProgress();
//     if (response.isOk) {
//       final myresponse = ProfileScreenModal.fromJson(response.body);
//       if (myresponse.status == true) {
//         return myresponse.data;
//       } else {
//         showToast(response.body['message'], color: green);
//       }
//     }
//     return null;
//   }

// ------------------------ booklistUrl---------------
  Future<List<BookListData>?> fetchbooklist(page) async {
    final response =
        await get(booklistUrl + page.toString(), headers: getHeader());
    print(response.request?.url);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myresponse = BookListModal.fromJson(myjson);
      if (myresponse.status == true) {
        return myresponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// ------------------------ employee list---------------
  Future<List<EmployeeData>?> employeeApiCall(
      String? checkIndate, String? checkOutdate, guestId, page) async {
    final body = {
      'fromDate': checkIndate,
      'toDate': checkOutdate,
      'guest': guestId,
      // 'page': page.toString()
    };
    showProgress();
    final response =
        await post(employeeUrl + page.toString(), body, headers: getHeader());
    hideProgress();
    // print(response.request?.url);
    // print(response.body);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      var myResponse = EmployeeListModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// ------------------------ Property repData name---------------

  Future<List<PropertyData>?> proApiCall() async {
    showProgress();
    final response = await get(propertylistsUrl, headers: getHeader());
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myResponse = PropertyListModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      }
      showToast(myjson['message']);
    }

    return null;
  }

// ------------------------ Room repData name---------------

  Future<List<RoomData>?> roomApiCall(String propertyId) async {
    final body = {'property_id': propertyId};
    showProgress();
    final response =
        await post(roomlistsUrl + propertyId, body, headers: getHeader());
    hideProgress();
    // print(response.request?.url);
    // print(response.body);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myResponse = RoomListModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      }
      showToast(myjson['message']);
    }

    return null;
  }

// ------------------------ Guest Search---------------

  Future<GuestSearchData?> guestsearchApiCall(String? name, page) async {
    showProgress();
    final response = await get('global/guestSearch?q=$name&page=$page',
        headers: getHeader());
    print(response.request?.url);
    //  print(response.body);
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myResponse = GuestSearchModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      }
      showToast(myjson['message']);
    }

    return null;
  }

// ------------------------ Guest Search---------------

// ------------------------ Room list---------------

  Future<AvailableRoomsData?> availableRoomsApiCall(
      {String? checkindate, String? checkoutdate, String? propertyid}) async {
    final body = {
      'property_id': propertyid,
      'checkin': checkindate,
      'checkout': checkoutdate
    };
    //print(body);
    showProgress();
    final response = await post(availableRoomsUrl, body, headers: getHeader());
    // print(response.request?.url);
    // print(response.body);
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myResponse = AvailableRoomsModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      }
      showToast(myjson['message']);
    }

    return null;
  }
// ------------------------ Bokking  list---------------

  Future<bool?> bookingcreateApiCall({
    String? guestId,
    String? propertyid,
    String? timein,
    String? checkoutdate,
    String? checkIndate,
    String? timeout,
    String? radioButtonid,
    String? ids,
    String? purpose,
    String? adult,
    String? child,
    String? infant,
    String? bookingguest,
    String? docone,
    String? onebase,
    String? doctwo,
    String? twobase,
    String? docthree,
    String? threebase,

    //  List<Map<String, String>>? pathList,
  }) async {
    final body = FormData({
      'guest_id': guestId,
      'property_id': propertyid,
      'checkin': checkIndate,
      'checkin_time': timein,
      'checkout': checkoutdate,
      'checkout_time': timeout,
      'room_ids': ids,
      'booking_for': radioButtonid,
      'other_checkin_name': bookingguest,
      'visit_purpose': purpose,
      'adult': adult,
      'child': child,
      'infant': infant,
      'document1_name': docone,
      'document1_file': onebase,
      'document2_name': doctwo,
      'document2_file': twobase,
      'document3_name': docthree,
      'document3_file': threebase,
      //  MultipartFile(imgPathone!,
      // Uri.parse('http://13.201.209.141/api/v1/'),
      //     filename: 'temp.jpeg'),
      // 'document2_name': doctwo,
      // 'document2_file': imgPathtwo,
      // "document3_name": docthree,
      // "document3_file": imgPaththree,
      // 'documents': pathList,
    });
    // body.fields.add(MapEntry(
    //     imgPathone, MultipartFile(imgPathone, filename: 'temp.jpg') as String));
    // print(body.fields);
    //body.files.add(imgPathone, MultipartFile(imgPathone, filename: filename))
    // pathList?.forEach((element) {
    //   body.files.add(MapEntry('documents[]',
    //       MultipartFile(element['path'], filename: '${element['name']}.jpg')));
    // });

    showProgress();
    print(body.fields);
    final response = await post(bookingcreateUrl, body, headers: getHeader());
    print(response.body);
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      //  if (myjson['status'] == true)
      if (myjson['status'] == true) {
        showToast(myjson['message'], color: green);
        return true;
      }
      showToast(myjson['message']);
    }
    return false;
  }

// ------------------------ Bokking  list---------------

  Future<bool?> updateApiCall({
    String? bookId,
    String? userId,
    String? statusid,
    String? propertyid,
    String? checkintime,
    String? checkoutdate,
    String? checkIndate,
    String? checkouttime,
    String? radioButtonid,
    String? ids,
    String? purpose,
    String? adult,
    String? child,
    String? infant,
    String? bookingguest,
    String? docone,
    String? onebase,
    String? doctwo,
    String? twobase,
    String? docthree,
    String? threebase,
    //  List<Map<String, String>>? pathList,
  }) async {
    final body = FormData({
      'status': statusid,
      'guest_id': userId,
      'property_id': propertyid,
      'checkin': checkIndate,
      'checkin_time': checkintime,
      'checkout': checkoutdate,
      'checkout_time': checkouttime,
      'booking_for': radioButtonid,
      'room_id': ids,
      'other_checkin_name': bookingguest,
      'visit_purpose': purpose,
      'adult': adult,
      'child': child,
      'infant': infant,
      'document1_name': docone,
      'document1_file': onebase,
      'document2_name': doctwo,
      'document2_file': twobase,
      'document3_name': docthree,
      'document3_file': threebase,
      // 'documents': pathList,
    });
    // print(body);
    //body.files.add(imgPathone, MultipartFile(imgPathone, filename: filename))
    // pathList?.forEach((element) {
    //   body.files.add(MapEntry('documents[]',
    //       MultipartFile(element['path'], filename: '${element['name']}.jpg')));
    // });
    print(body);
    showProgress();
    final response =
        await post(updateUrl + bookId.toString(), body, headers: getHeader());
    print(response.request?.url);
    print(response.body);
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      //  if (myjson['status'] == true)
      if (myjson['status'] == true) {
        showToast(myjson['message'], color: green);
        return true;
      }
      showToast(myjson['message']);
    }
    return false;
  }

// ------------------------ All Bokking  list---------------

  Future<List<AllBookingData>?> allBookingApiCall(page) async {
    final response =
        await get(allBokkingUrl + page.toString(), headers: getHeader());
    print(response.request?.url);

    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myresponse = AllBookingModal.fromJson(myjson);
      if (myresponse.status == true) {
        return myresponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// ------------------------ Advanced Booking Data  list---------------

  Future<List<AdvancedBookingData>?> advancedbookingApiCall(page) async {
    final response =
        await get(advancedbookingUrl + page.toString(), headers: getHeader());
    print(response.request?.url);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myresponse = AdvancedBookingModal.fromJson(myjson);
      if (myresponse.status == true) {
        return myresponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }
// ------------------------ Advanced Booking Data  list---------------

  Future<List<CheckinBookingData>?> checkinbookingApiCall(page) async {
    final response =
        await get(checkinbookingUrl + page.toString(), headers: getHeader());
    print(response.request?.url);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myresponse = CheckinBookingModal.fromJson(myjson);
      if (myresponse.status == true) {
        return myresponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// ------------------------ allemployeeApiCall list---------------

  Future<List<AllEmployeeListData>?> allemployeeApiCall(page) async {
    final response =
        await get('$allemployeesUrl?page=$page', headers: getHeader());
    print(response.request?.url);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myresponse = AllEmployeeListModal.fromJson(myjson);
      if (myresponse.status == true) {
        return myresponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// ------------------------ allemployeeDetailApiCall list---------------
  Future<EmployeeDetailData?> allemployeeDetailApiCall(
      String employeeId) async {
    final response =
        await get(allemployeeDetailUrl + employeeId, headers: getHeader());
    print(response.request?.url);
    print(response.body);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myresponse = EmployeeDetailModal.fromJson(myjson);
      if (myresponse.status == true) {
        return myresponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }

// ------------------------ Company repData name---------------

  Future<List<CompanyListsData>?> companyListsApiCall() async {
    showProgress();
    final response = await get(companyListsUrl, headers: getHeader());
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myResponse = CompanyListsModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      }
      showToast(myjson['message']);
    }

    return null;
  }

// ------------------------ country ApiCall  ---------------

  Future<List<CountryListData>?> countryApiCall() async {
    showProgress();
    final response = await get(countryUrl, headers: getHeader());
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myResponse = CountryListModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      }
      showToast(myjson['message']);
    }

    return null;
  }

// ------------------------ state ApiCall  ---------------
  Future<List<StateListData>?> stateApiCall(String countryid) async {
    showProgress();
    final response = await get(stateUrl + countryid, headers: getHeader());
    hideProgress();
    print(response.request?.url);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myResponse = StateListModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      }
      showToast(myjson['message']);
    }

    return null;
  }

// ------------------------ createempApiCall  list---------------

  Future<bool?> createempApiCall({
    String? image,
    String? companyid,
    String? name,
    String? email,
    String? contact,
    String? altcontact,
    String? empid,
    String? address,
    String? city,
    String? countryid,
    String? stateid,
    String? radioButtonid,
    String? docone,
    String? onebase,
    String? doctwo,
    String? twobase,
    String? docthree,
    String? threebase,
  }) async {
    final body = FormData({
      'name': name,
      'profile_photo': image,
      'email': email,
      'mobile': contact,
      'company_id': companyid,
      'employee_id': empid,
      'alt_contact': altcontact,
      'address': address,
      'city': city,
      'country_id': countryid,
      'state_id': stateid,
      'food_complement': radioButtonid,
      'document1_name': docone,
      'document1_file': onebase,
      'document2_name': doctwo,
      'document2_file': twobase,
      'document3_name': docthree,
      'document3_file': threebase,
    });

    showProgress();

    final response = await post(createempUrl, body, headers: getHeader());
    // print(body.fields);
    print(response.body);
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      //  if (myjson['status'] == true)
      if (myjson['status'] == true) {
        showToast(myjson['message'], color: green);
        return true;
      }
      showToast(myjson['message']);
    }
    return false;
  }

// ------------------------ Edit pApiCall  list---------------

  Future<bool?> editempApiCall({
    String? profilePath,
    String? id,
    String? companyid,
    String? name,
    String? email,
    String? contact,
    String? altcontact,
    String? empid,
    String? address,
    String? city,
    String? countryid,
    String? stateid,
    String? radioButtonid,
    String? docone,
    String? onebase,
    String? doctwo,
    String? twobase,
    String? docthree,
    String? threebase,
  }) async {
    final body = FormData({
      'name': name,
      'profile_photo': profilePath,
      'email': email,
      'mobile': contact,
      'company_id': companyid,
      'employee_id': empid,
      'alt_contact': altcontact,
      'address': address,
      'city': city,
      'country_id': countryid,
      'state_id': stateid,
      'food_complement': radioButtonid,
      'document1_name': docone,
      'document1_file': onebase,
      'document2_name': doctwo,
      'document2_file': twobase,
      'document3_name': docthree,
      'document3_file': threebase,
    });

    showProgress();

    final response =
        await post(editempUrl + id.toString(), body, headers: getHeader());
    print(body.fields);
    print(response.body);
    print(response.request?.url);
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      //  if (myjson['status'] == true)
      if (myjson['status'] == true) {
        showToast(myjson['message'], color: green);
        return true;
      }
      showToast(myjson['message']);
    }
    return false;
  }

  // ------------------------ Guest Search---------------

  Future<GuestSearchData?> employeesearchApiCall(String? name, page) async {
    showProgress();
    final response = await get('global/guestSearch?q=$name&page=$page',
        headers: getHeader());
    print(response.request?.url);
    //  print(response.body);
    hideProgress();
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myResponse = GuestSearchModal.fromJson(myjson);
      if (myResponse.status == true) {
        return myResponse.data;
      }
      showToast(myjson['message']);
    }

    return null;
  }

// ------------------------ Employee Search---------------

  Future<List<AllEmployeeListData>?> searchlemployeeApiCall(
      String? name, page) async {
    //global/guestSearch?q=$name&page=$page
    //employees/lists?guest=Ankita singh&page=1
    final response = await get('employees/lists?guest=$name&page=$page',
        headers: getHeader());
    print(response.request?.url);
    if (response.isOk) {
      final myjson = jsonDecode(response.body);
      final myresponse = AllEmployeeListModal.fromJson(myjson);
      if (myresponse.status == true) {
        return myresponse.data;
      } else {
        showToast(myjson['message']);
      }
    }
    return null;
  }
}










 

// final String guestsearchUrl = 'global/guestSearch?q=a&page=1';
//host/gift/list/$hostId?type=$type



