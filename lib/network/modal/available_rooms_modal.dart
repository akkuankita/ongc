class AvailableRoomsModal {
  bool? status;
  AvailableRoomsData? data;
  String? message;

  AvailableRoomsModal({
    this.status,
    this.data,
    this.message,
  });

  factory AvailableRoomsModal.fromJson(Map<String, dynamic> json) =>
      AvailableRoomsModal(
        status: json["status"],
        data: json["data"] == null
            ? null
            : AvailableRoomsData.fromJson(json["data"]),
        message: json["message"],
      );
}

class AvailableRoomsData {
  final bool? enableMultipleSelection;
  final List<Record>? records;

  AvailableRoomsData({
    this.enableMultipleSelection,
    this.records,
  });

  factory AvailableRoomsData.fromJson(Map<String, dynamic> json) =>
      AvailableRoomsData(
        enableMultipleSelection: json["enable_multiple_selection"],
        records: json["records"] == null
            ? []
            : List<Record>.from(
                json["records"]!.map((x) => Record.fromJson(x))),
      );
}

class Record {
  final int? floor;
  final List<Detail>? details;

  Record({
    this.floor,
    this.details,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        floor: json["floor"],
        details: json["details"] == null
            ? []
            : List<Detail>.from(
                json["details"]!.map((x) => Detail.fromJson(x))),
      );
}

class Detail {
  final String? category;
  final List<Room>? rooms;

  Detail({
    this.category,
    this.rooms,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        category: json["category"],
        rooms: json["rooms"] == null
            ? []
            : List<Room>.from(json["rooms"]!.map((x) => Room.fromJson(x))),
      );
}

class Room {
  final int? id;
  final int? propertyId;
  final int? categoryId;
  final int? floorNumber;
  final String? roomName;
  final String? price;
  final String? image;
  bool isSelected;
  final String? category;

  Room({
    this.id,
    this.propertyId,
    this.categoryId,
    this.floorNumber,
    this.roomName,
    this.price,
    this.image,
    required this.isSelected,
    this.category,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        propertyId: json["property_id"],
        categoryId: json["category_id"],
        floorNumber: json["floor_number"],
        roomName: json["room_name"],
        price: json["price"],
        image: json["image"],
        isSelected: json["isSelected"] ?? false,
        category: json["category"],
      );
}
