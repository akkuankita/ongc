class BookListModal {
  bool? status;
  List<BookListData>? data;
  String? message;

  BookListModal({
    this.status,
    this.data,
    this.message,
  });

  factory BookListModal.fromJson(Map<String, dynamic> json) => BookListModal(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<BookListData>.from(
                json["data"]!.map((x) => BookListData.fromJson(x))),
        message: json["message"],
      );
}

class BookListData {
  int? id;
  String? name;
  String? companyName;
  String? property;
  String? room;
  String? checkin;
  String? checkout;

  BookListData({
    this.id,
    this.name,
    this.companyName,
    this.property,
    this.room,
    this.checkin,
    this.checkout,
  });

  factory BookListData.fromJson(Map<String, dynamic> json) => BookListData(
        id: json["id"],
        name: json["name"],
        companyName: json["company_name"],
        property: json["property"],
        room: json["room"],
        checkin: json["checkin"],
        checkout: json["checkout"],
      );
}
