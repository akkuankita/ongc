class CheckinBookingModal {
  bool? status;
  List<CheckinBookingData>? data;
  String? message;

  CheckinBookingModal({
    this.status,
    this.data,
    this.message,
  });

  factory CheckinBookingModal.fromJson(Map<String, dynamic> json) =>
      CheckinBookingModal(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<CheckinBookingData>.from(
                json["data"]!.map((x) => CheckinBookingData.fromJson(x))),
        message: json["message"],
      );
}

class CheckinBookingData {
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

  CheckinBookingData({
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

  factory CheckinBookingData.fromJson(Map<String, dynamic> json) =>
      CheckinBookingData(
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
