class ProfileScreenModal {
      bool? status;
      ProfileData? data;
      dynamic message;

    ProfileScreenModal({
        this.status,
        this.data,
        this.message,
    });

    factory ProfileScreenModal.fromJson(Map<String, dynamic> json) => ProfileScreenModal(
        status: json["status"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
        message: json["message"],
    );

    
}

class ProfileData {
      int? id;
      String? name;
      String? email;
      String? mobile;
      String? apiToken;
      String? photo;

    ProfileData({
        this.id,
        this.name,
        this.email,
        this.mobile,
        this.apiToken,
        this.photo,
    });

    factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobile: json["mobile"],
        apiToken: json["api_token"],
        photo: json["photo"],
    );

   
}
