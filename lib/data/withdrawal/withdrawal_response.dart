

class WithdrawalResponse {
  String? status;
  String? message;
  Data? data;

  WithdrawalResponse({
    this.status,
    this.message,
    this.data,
  });

  factory WithdrawalResponse.fromJson(Map<String, dynamic> json) => WithdrawalResponse(
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
  String? type;
  String? amount;
  int? vendorId;
  String? status;
  Metadata? metadata;
  String? reference;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.type,
    this.amount,
    this.vendorId,
    this.status,
    this.metadata,
    this.reference,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    type: json["type"],
    amount: json["amount"],
    vendorId: json["vendor_id"],
    status: json["status"],
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    reference: json["reference"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "amount": amount,
    "vendor_id": vendorId,
    "status": status,
    "metadata": metadata?.toJson(),
    "reference": reference,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}

class Metadata {
  String? source;
  String? bankName;
  String? accountNumber;
  String? accountName;
  String? recipientCode;

  Metadata({
    this.source,
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.recipientCode,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    source: json["source"],
    bankName: json["bank_name"],
    accountNumber: json["account_number"],
    accountName: json["account_name"],
    recipientCode: json["recipient_code"],
  );

  Map<String, dynamic> toJson() => {
    "source": source,
    "bank_name": bankName,
    "account_number": accountNumber,
    "account_name": accountName,
    "recipient_code": recipientCode,
  };
}
