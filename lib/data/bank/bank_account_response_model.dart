

class BankAccountResponse {
  String? status;
  String? message;
  List<BankAccount>? data;

  BankAccountResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BankAccountResponse.fromJson(Map<String, dynamic> json) => BankAccountResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<BankAccount>.from(json["data"]!.map((x) => BankAccount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BankAccount {
  int? id;
  String? bankName;
  String? bankCode;
  String? bankSlug;
  String? accountName;
  String? accountNumber;
  int? vendorId;
  DateTime? createdAt;
  DateTime? updatedAt;

  BankAccount({
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

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
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
