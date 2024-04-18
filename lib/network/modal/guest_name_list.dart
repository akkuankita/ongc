class GuestSearchModal {
  bool? status;
  GuestSearchData? data;
  String? message;

  GuestSearchModal({
    this.status,
    this.data,
    this.message,
  });

  factory GuestSearchModal.fromJson(Map<String, dynamic> json) => GuestSearchModal(
        status: json["status"],
        data: json["data"] == null ? null : GuestSearchData.fromJson(json["data"]),
        message: json["message"],
      );
}

class GuestSearchData {
    List<GuestItem>? items;
    int? totalCount;

  GuestSearchData({
    this.items,
    this.totalCount,
  });

  factory GuestSearchData.fromJson(Map<String, dynamic> json) => GuestSearchData(
        items: json["items"] == null
            ? []
            : List<GuestItem>.from(json["items"]!.map((x) => GuestItem.fromJson(x))),
        totalCount: json["total_count"],
      );
}

class GuestItem {
  int? id;
  String? name;
  int? profileId;
  int? companyId;
  String? companyName;

  GuestItem({
    this.id,
    this.name,
    this.profileId,
    this.companyId,
    this.companyName,
  });

  factory GuestItem.fromJson(Map<String, dynamic> json) => GuestItem(
        id: json["id"],
        name: json["name"],
        profileId: json["profile_id"],
        companyId: json["company_id"],
        companyName: json["company_name"],
      );
}
