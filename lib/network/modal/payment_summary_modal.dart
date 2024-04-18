class PaymentSummaryModal {
  bool? status;
  PaymentSummaryData? data;
  String? message;

  PaymentSummaryModal({
    this.status,
    this.data,
    this.message,
  });

  factory PaymentSummaryModal.fromJson(Map<String, dynamic> json) =>
      PaymentSummaryModal(
        status: json["status"],
        data: json["data"] == null
            ? null
            : PaymentSummaryData.fromJson(json["data"]),
        message: json["message"],
      );
}

class PaymentSummaryData {
  Summary? summary;
  List<SummaryRecord>? records;

  PaymentSummaryData({
    this.summary,
    this.records,
  });

  factory PaymentSummaryData.fromJson(Map<String, dynamic> json) =>
      PaymentSummaryData(
        summary:
            json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        records: json["records"] == null
            ? []
            : List<SummaryRecord>.from(
                json["records"]!.map((x) => SummaryRecord.fromJson(x))),
      );
}

class SummaryRecord {
  final int? id;
  final String? name;
  final String? userPhoto;
  final String? userMobile;
  final String? userEmail;
  final String? userEmployeeId;
  final String? companyName;
  final String? bookFor;
  final String? property;
  final String? room;
  final String? checkin;
  final String? checkout;
  final int? rentAmount;
  final int? foodAmount;
  final String? status;

  SummaryRecord({
    this.id,
    this.name,
    this.userPhoto,
    this.userMobile,
    this.userEmail,
    this.userEmployeeId,
    this.companyName,
    this.bookFor,
    this.property,
    this.room,
    this.checkin,
    this.checkout,
    this.rentAmount,
    this.foodAmount,
    this.status,
  });

  factory SummaryRecord.fromJson(Map<String, dynamic> json) => SummaryRecord(
        id: json["id"],
        name: json["name"],
        userPhoto: json["user_photo"],
        userMobile: json["user_mobile"],
        userEmail: json["user_email"],
        userEmployeeId: json["user_employee_id"],
        companyName: json["company_name"],
        bookFor: json["book_for"],
        property: json["property"],
        room: json["room"],
        checkin: json["checkin"],
        checkout: json["checkout"],
        rentAmount: json["rent_amount"],
        foodAmount: json["food_amount"],
        status: json["status"],
      );
}

class Summary {
  int? roomOccupancy;
  String? rentAmount;
  int? foodAmount;

  Summary({
    this.roomOccupancy,
    this.rentAmount,
    this.foodAmount,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        roomOccupancy: json["RoomOccupancy"],
        rentAmount: json["rent_amount"],
        foodAmount: json["food_amount"],
      );
}
