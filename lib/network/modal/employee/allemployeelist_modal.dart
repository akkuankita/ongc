class AllEmployeeListModal {
  bool? status;
  List<AllEmployeeListData>? data;
  String? message;

  AllEmployeeListModal({
    this.status,
    this.data,
    this.message,
  });

  factory AllEmployeeListModal.fromJson(Map<String, dynamic> json) =>
      AllEmployeeListModal(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<AllEmployeeListData>.from(
                json["data"]!.map((x) => AllEmployeeListData.fromJson(x))),
        message: json["message"],
      );
}

class AllEmployeeListData {
  final int? id;
  final int? userId;
  final String? userPhoto;
  final String? userName;
  final String? userEmail;
  final String? userMobile;
  final String? userCompany;

  AllEmployeeListData({
    this.id,
    this.userId,
    this.userPhoto,
    this.userName,
    this.userEmail,
    this.userMobile,
    this.userCompany,
  });

  factory AllEmployeeListData.fromJson(Map<String, dynamic> json) =>
      AllEmployeeListData(
        id: json["id"],
        userId: json["user_id"],
        userPhoto: json["user_photo"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userMobile: json["user_mobile"],
        userCompany: json["user_company"]!,
      );
}
