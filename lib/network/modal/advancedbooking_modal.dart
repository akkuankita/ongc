class AdvancedBookingModal {
  bool? status;
  List<AdvancedBookingData>? data;
  String? message;

  AdvancedBookingModal({
    this.status,
    this.data,
    this.message,
  });

  factory AdvancedBookingModal.fromJson(Map<String, dynamic> json) =>
      AdvancedBookingModal(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<AdvancedBookingData>.from(
                json["data"]!.map((x) => AdvancedBookingData.fromJson(x))),
        message: json["message"],
      );
}

class AdvancedBookingData {
  final int? id;
  final String? name;
  final String? userPhoto;
  final String? userMobile;
  final String? userEmail;
  final String? userEmployeeId;
  final String? companyName;
  final String? property;
  final String? room;
  final String? checkin;
  final String? checkout;
  final String? status;

  AdvancedBookingData({
    this.id,
    this.name,
    this.userPhoto,
    this.userMobile,
    this.userEmail,
    this.userEmployeeId,
    this.companyName,
    this.property,
    this.room,
    this.checkin,
    this.checkout,
    this.status,
  });

  factory AdvancedBookingData.fromJson(Map<String, dynamic> json) =>
      AdvancedBookingData(
        id: json["id"],
        name: json["name"],
        userPhoto: json["user_photo"],
        userMobile: json["user_mobile"],
        userEmail: json["user_email"],
        userEmployeeId: json["user_employee_id"],
        companyName: json["company_name"]!,
        property: json["property"],
        room: json["room"],
        checkin: json["checkin"],
        checkout: json["checkout"],
        status: json["status"]!,
      );
}
