class CompanyListsModal {
  bool? status;
  List<CompanyListsData>? data;
  String? message;

  CompanyListsModal({
    this.status,
    this.data,
    this.message,
  });

  factory CompanyListsModal.fromJson(Map<String, dynamic> json) =>
      CompanyListsModal(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<CompanyListsData>.from(
                json["data"]!.map((x) => CompanyListsData.fromJson(x))),
        message: json["message"],
      );
}

class CompanyListsData {
  int? id;
  String? name;

  CompanyListsData({
    this.id,
    this.name,
  });

  factory CompanyListsData.fromJson(Map<String, dynamic> json) =>
      CompanyListsData(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
