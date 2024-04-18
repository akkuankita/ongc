class BookDetailModal {
  final bool? status;
  final BookDetailData? data;
  final String? message;

  BookDetailModal({
    this.status,
    this.data,
    this.message,
  });

  factory BookDetailModal.fromJson(Map<String, dynamic> json) =>
      BookDetailModal(
        status: json["status"],
        data:
            json["data"] == null ? null : BookDetailData.fromJson(json["data"]),
        message: json["message"],
      );
}

class BookDetailData {
  String? bookingId;
  int? statusId;
  String? status;
  List<AvailableStatus>? availableStatus;
  int? rentAmount;
  int? foodAmount;
  int? userId;
  String? userPhoto;
  String? userMobile;
  String? userEmail;
  String? userName;
  int? propertyId;
  String? propertyName;
  int? roomId;
  String? roomName;
  String? checkinDate;
  String? checkinTime;
  String? formattedCheckinDate;
  String? checkoutDate;
  String? checkoutTime;
  String? formattedCheckoutDate;
  int? bookingForId;
  String? bookingFor;
  String? bookingForGuest;
  String? visitPurpose;
  int? adult;
  int? child;
  int? infant;
  List<Document>? documents;

  BookDetailData({
    this.bookingId,
    this.statusId,
    this.status,
    this.availableStatus,
    this.rentAmount,
    this.foodAmount,
    this.userId,
    this.userPhoto,
    this.userMobile,
    this.userEmail,
    this.userName,
    this.propertyId,
    this.propertyName,
    this.roomId,
    this.roomName,
    this.checkinDate,
    this.checkinTime,
    this.formattedCheckinDate,
    this.checkoutDate,
    this.checkoutTime,
    this.formattedCheckoutDate,
    this.bookingForId,
    this.bookingFor,
    this.bookingForGuest,
    this.visitPurpose,
    this.adult,
    this.child,
    this.infant,
    this.documents,
  });

  factory BookDetailData.fromJson(Map<String, dynamic> json) => BookDetailData(
        bookingId: json["booking_id"],
        statusId: json["status_id"],
        status: json["status"],
        availableStatus: json["available_status"] == null
            ? []
            : List<AvailableStatus>.from(json["available_status"]!
                .map((x) => AvailableStatus.fromJson(x))),
        rentAmount: json["rent_amount"],
        foodAmount: json["food_amount"],
        userId: json["user_id"],
        userPhoto: json["user_photo"],
        userMobile: json["user_mobile"],
        userEmail: json["user_email"],
        userName: json["user_name"],
        propertyId: json["property_id"],
        propertyName: json["property_name"],
        roomId: json["room_id"],
        roomName: json["room_name"],
        checkinDate: json["checkin_date"],
        checkinTime: json["checkin_time"],
        formattedCheckinDate: json["formatted_checkin_date"],
        checkoutDate: json["checkout_date"],
        checkoutTime: json["checkout_time"],
        bookingForId: json["booking_for_id"],
        formattedCheckoutDate: json["formatted_checkout_date"],
        bookingFor: json["booking_for"],
        bookingForGuest: json["booking_for_guest"],
        visitPurpose: json["visit_purpose"],
        adult: json["adult"],
        child: json["child"],
        infant: json["infant"],
        documents: json["documents"] == null
            ? []
            : List<Document>.from(
                json["documents"]!.map((x) => Document.fromJson(x))),
      );
}

class AvailableStatus {
  final int? id;
  final String? name;

  AvailableStatus({
    this.id,
    this.name,
  });

  factory AvailableStatus.fromJson(Map<String, dynamic> json) =>
      AvailableStatus(
        id: json["id"],
        name: json["name"],
      );
}

class Document {
  final int? id;
  final String? name;
  final String? url;

  Document({
    this.id,
    this.name,
    this.url,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        name: json["name"],
        url: json["url"],
      );
}
