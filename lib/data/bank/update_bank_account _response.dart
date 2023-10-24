

class UpdateBankAccountResponseModel {
  String? status;
  String? message;
  Data? data;

  UpdateBankAccountResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UpdateBankAccountResponseModel.fromJson(Map<String, dynamic> json) => UpdateBankAccountResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? bankName;
  String? bankCode;
  String? bankSlug;
  String? accountName;
  String? accountNumber;
  int? vendorId;
  DateTime? createdAt;
  int? id;

  Data({
    this.bankName,
    this.bankCode,
    this.bankSlug,
    this.accountName,
    this.accountNumber,
    this.vendorId,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bankName: json["bank_name"],
    bankCode: json["bank_code"],
    bankSlug: json["bank_slug"],
    accountName: json["account_name"],
    accountNumber: json["account_number"],
    vendorId: json["vendor_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "bank_name": bankName,
    "bank_code": bankCode,
    "bank_slug": bankSlug,
    "account_name": accountName,
    "account_number": accountNumber,
    "vendor_id": vendorId,
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
