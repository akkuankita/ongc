class PaymentWiseExportModal {
  bool? status;
  PaymentWiseExportData? data;
  String? message;

  PaymentWiseExportModal({
    this.status,
    this.data,
    this.message,
  });

  factory PaymentWiseExportModal.fromJson(Map<String, dynamic> json) =>
      PaymentWiseExportModal(
        status: json["status"],
        data: json["data"] == null ? null : PaymentWiseExportData.fromJson(json["data"]),
        message: json["message"],
      );
}

class PaymentWiseExportData {
  String? file;
  String? downloadUrl;

  PaymentWiseExportData({
    this.file,
    this.downloadUrl,
  });

  factory PaymentWiseExportData.fromJson(Map<String, dynamic> json) => PaymentWiseExportData(
        file: json["file"],
        downloadUrl: json["download_url"],
      );
}
