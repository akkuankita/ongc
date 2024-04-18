class CountryListModal {
  bool? status;
  List<CountryListData>? data;
  String? message;

  CountryListModal({
    this.status,
    this.data,
    this.message,
  });

  factory CountryListModal.fromJson(Map<String, dynamic> json) =>
      CountryListModal(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<CountryListData>.from(
                json["data"]!.map((x) => CountryListData.fromJson(x))),
        message: json["message"],
      );
}

class CountryListData {
  int? id;
  String? name;

  CountryListData({
    this.id,
    this.name,
  });

  factory CountryListData.fromJson(Map<String, dynamic> json) =>
      CountryListData(
        id: json["id"],
        name: json["name"],
      );
}
