
class DeleteBankAccountResponse {
  String? status;
  String? message;
  Data? data;

  DeleteBankAccountResponse({
    this.status,
    this.message,
    this.data,
  });

  factory DeleteBankAccountResponse.fromJson(Map<String, dynamic> json) => DeleteBankAccountResponse(
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
  int? id;
  String? bankName;
  String? bankCode;
  String? bankSlug;
  String? accountName;
  String? accountNumber;
  int? vendorId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.bankName,
    this.bankCode,
    this.bankSlug,
    this.accountName,
    this.accountNumber,
    this.vendorId,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    bankName: json["bank_name"],
    bankCode: json["bank_code"],
    bankSlug: json["bank_slug"],
    accountName: json["account_name"],
    accountNumber: json["account_number"],
    vendorId: json["vendor_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bank_name": bankName,
    "bank_code": bankCode,
    "bank_slug": bankSlug,
    "account_name": accountName,
    "account_number": accountNumber,
    "vendor_id": vendorId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
