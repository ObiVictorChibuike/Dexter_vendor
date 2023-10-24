
class TransactionHistoryResponseModel {
  String? status;
  String? message;
  List<Datum>? data;

  TransactionHistoryResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory TransactionHistoryResponseModel.fromJson(Map<String, dynamic> json) => TransactionHistoryResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  int? vendorId;
  String? type;
  String? status;
  String? amount;
  String? reference;
  String? description;
  dynamic metadata;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.vendorId,
    this.type,
    this.status,
    this.amount,
    this.reference,
    this.description,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    vendorId: json["vendor_id"],
    type: json["type"],
    status: json["status"],
    amount: json["amount"],
    reference: json["reference"],
    description: json["description"],
    metadata: json["metadata"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "vendor_id": vendorId,
    "type": type,
    "status": status,
    "amount": amount,
    "reference": reference,
    "description": description,
    "metadata": metadata,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

enum Status {
  COMPLETED,
  FAILED,
  PENDING
}

final statusValues = EnumValues({
  "completed": Status.COMPLETED,
  "failed": Status.FAILED,
  "pending": Status.PENDING
});

enum Type {
  CREDIT,
  DEBIT
}

final typeValues = EnumValues({
  "credit": Type.CREDIT,
  "debit": Type.DEBIT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
