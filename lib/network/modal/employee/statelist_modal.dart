class StateListModal {
  bool? status;
  List<StateListData>? data;
  String? message;

  StateListModal({
    this.status,
    this.data,
    this.message,
  });

  factory StateListModal.fromJson(Map<String, dynamic> json) => StateListModal(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<StateListData>.from(
                json["data"]!.map((x) => StateListData.fromJson(x))),
        message: json["message"],
      );
}

class StateListData {
  final int? id;
  final String? name;

  StateListData({
    this.id,
    this.name,
  });

  factory StateListData.fromJson(Map<String, dynamic> json) => StateListData(
        id: json["id"],
        name: json["name"],
      );
}
