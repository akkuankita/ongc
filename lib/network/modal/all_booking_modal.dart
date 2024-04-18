class AllBookingModal {
  bool? status;
  List<AllBookingData>? data;
  String? message;

  AllBookingModal({
    this.status,
    this.data,
    this.message,
  });

  factory AllBookingModal.fromJson(Map<String, dynamic> json) =>
      AllBookingModal(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<AllBookingData>.from(
                json["data"]!.map((x) => AllBookingData.fromJson(x))),
        message: json["message"],
      );
}

class AllBookingData {
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

  AllBookingData({
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

  factory AllBookingData.fromJson(Map<String, dynamic> json) => AllBookingData(
        id: json["id"],
        name: json["name"],
        userPhoto: json["user_photo"],
        userMobile: json["user_mobile"],
        userEmail: json["user_email"],
        userEmployeeId: json["user_employee_id"],
        companyName: json["company_name"],
        property: json["property"],
        room: json["room"],
        checkin: json["checkin"],
        checkout: json["checkout"],
        status: json["status"],
      );
}
