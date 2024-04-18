 
class EmployeeListModal {
      bool? status;
      List<EmployeeData>? data;
      String? message;

    EmployeeListModal({
        this.status,
        this.data,
        this.message,
    });

    factory EmployeeListModal.fromJson(Map<String, dynamic> json) => EmployeeListModal(
        status: json["status"],
        data: json["data"] == null ? [] : List<EmployeeData>.from(json["data"]!.map((x) => EmployeeData.fromJson(x))),
        message: json["message"],
    );

    
}

class EmployeeData {
    final int? id;
    final String? name;
    final String? userPhoto;
    final String? userMobile;
    final String? userEmail;
    final dynamic userEmployeeId;
    final String? companyName;
    final String? bookFor;
    final String? property;
    final String? room;
    final String? checkin;
    final String? checkout;
    final int? rentAmount;
    final int? foodAmount;
    final String? status;

    EmployeeData({
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

    factory EmployeeData.fromJson(Map<String, dynamic> json) => EmployeeData(
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
