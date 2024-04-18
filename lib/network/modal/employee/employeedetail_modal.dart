class EmployeeDetailModal {
  bool? status;
  EmployeeDetailData? data;
  String? message;

  EmployeeDetailModal({
    this.status,
    this.data,
    this.message,
  });

  factory EmployeeDetailModal.fromJson(Map<String, dynamic> json) =>
      EmployeeDetailModal(
        status: json["status"],
        data: json["data"] == null
            ? null
            : EmployeeDetailData.fromJson(json["data"]),
        message: json["message"],
      );
}

class EmployeeDetailData {
  final int? id;
  final int? userId;
  final String? userPhoto;
  final String? userName;
  final String? userEmail;
  final String? userMobile;
  final String? userCompany;
  final int? userCompanyId;
  final bool? emailVerified;
  final String? altContact;
  final String? employeeId;
  final String? address;
  final String? city;
  final int? stateId;
  final String? state;
  final int? countryId;
  final String? country;
  final int? foodComplementary;
  final List<Document>? documents;

  EmployeeDetailData({
    this.id,
    this.userId,
    this.userPhoto,
    this.userName,
    this.userEmail,
    this.userMobile,
    this.userCompany,
    this.userCompanyId,
    this.emailVerified,
    this.altContact,
    this.employeeId,
    this.address,
    this.city,
    this.stateId,
    this.state,
    this.countryId,
    this.country,
    this.foodComplementary,
    this.documents,
  });

  factory EmployeeDetailData.fromJson(Map<String, dynamic> json) =>
      EmployeeDetailData(
        id: json["id"],
        userId: json["user_id"],
        userPhoto: json["user_photo"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userMobile: json["user_mobile"],
        userCompany: json["user_company"],
        userCompanyId: json["user_company_id"],
        emailVerified: json["email_verified"],
        altContact: json["alt_contact"],
        employeeId: json["employee_id"],
        address: json["address"],
        city: json["city"],
        stateId: json["state_id"],
        state: json["state"],
        countryId: json["country_id"],
        country: json["country"],
        foodComplementary: json["food_complementary"],
        documents: json["documents"] == null
            ? []
            : List<Document>.from(
                json["documents"]!.map((x) => Document.fromJson(x))),
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
