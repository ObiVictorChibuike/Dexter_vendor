
class UpdateVendorProfileResponse {
  String? status;
  String? message;
  Data? data;

  UpdateVendorProfileResponse({
    this.status,
    this.message,
    this.data,
  });

  factory UpdateVendorProfileResponse.fromJson(Map<String, dynamic> json) => UpdateVendorProfileResponse(
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
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? availableBalance;
  String? image;
  String? qualification;
  String? nin;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.availableBalance,
    this.image,
    this.qualification,
    this.nin,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    availableBalance: json["available_balance"],
    image: json["image"],
    qualification: json["qualification"],
    nin: json["nin"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "available_balance": availableBalance,
    "image": image,
    "qualification": qualification,
    "nin": nin,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
