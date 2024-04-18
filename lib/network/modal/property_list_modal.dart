class PropertyListModal {
  bool? status;
  List<PropertyData>? data;
  String? message;

  PropertyListModal({
    this.status,
    this.data,
    this.message,
  });

  factory PropertyListModal.fromJson(Map<String, dynamic> json) =>
      PropertyListModal(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<PropertyData>.from(
                json["data"]!.map((x) => PropertyData.fromJson(x))),
        message: json["message"],
      );
}

class PropertyData {
  int? id;
  String? name;

  PropertyData({
    this.id,
    this.name,
  });

  factory PropertyData.fromJson(Map<String, dynamic> json) => PropertyData(
        id: json["id"],
        name: json["name"],
      );
}
