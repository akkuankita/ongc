 
class RoomListModal {
      bool? status;
      List<RoomData>? data;
      String? message;

    RoomListModal({
        this.status,
        this.data,
        this.message,
    });

    factory RoomListModal.fromJson(Map<String, dynamic> json) => RoomListModal(
        status: json["status"],
        data: json["data"] == null ? [] : List<RoomData>.from(json["data"]!.map((x) => RoomData.fromJson(x))),
        message: json["message"],
    );
 
}

class RoomData {
    final int? id;
    final String? name;

    RoomData({
        this.id,
        this.name,
    });

    factory RoomData.fromJson(Map<String, dynamic> json) => RoomData(
        id: json["id"],
        name: json["name"],
    );

  
}
