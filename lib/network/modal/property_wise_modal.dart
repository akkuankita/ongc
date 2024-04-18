 
class PropertyWiseModal {
    final bool? status;
    final List<PropertyWiseData>? data;
    final String? message;

    PropertyWiseModal({
        this.status,
        this.data,
        this.message,
    });

    factory PropertyWiseModal.fromJson(Map<String, dynamic> json) => PropertyWiseModal(
        status: json["status"],
        data: json["data"] == null ? [] : List<PropertyWiseData>.from(json["data"]!.map((x) => PropertyWiseData.fromJson(x))),
        message: json["message"],
    );

   
}

class PropertyWiseData {
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

    PropertyWiseData({
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

    factory PropertyWiseData.fromJson(Map<String, dynamic> json) => PropertyWiseData(
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
