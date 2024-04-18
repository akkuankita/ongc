 
class HomeScreenModal {
      bool? status;
      List<HomeData>? data;
      dynamic message;

    HomeScreenModal({
        this.status,
        this.data,
        this.message,
    });

    factory HomeScreenModal.fromJson(Map<String, dynamic> json) => HomeScreenModal(
        status: json["status"],
        data: json["data"] == null ? [] : List<HomeData>.from(json["data"]!.map((x) => HomeData.fromJson(x))),
        message: json["message"],
    );

   
}

class HomeData {
      String? propertyName;
      String? propertyImage;
      String? propertyCity;
      int? totalRoom;
      int? occupied;

    HomeData({
        this.propertyName,
        this.propertyImage,
        this.propertyCity,
        this.totalRoom,
        this.occupied,
    });

    factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        propertyName: json["property_name"],
        propertyImage: json["property_image"],
        propertyCity: json["property_city"],
        totalRoom: json["total_room"],
        occupied: json["occupied"],
    );

    
}
