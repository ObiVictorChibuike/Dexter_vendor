

class BookingResponseModel {
  String? status;
  String? message;
  List<Bookings>? data;

  BookingResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) => BookingResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Bookings>.from(json["data"]!.map((x) => Bookings.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Bookings {
  int? id;
  String? reference;
  String? status;
  String? paymentStatus;
  int? addressId;
  int? userId;
  int? businessId;
  DateTime? scheduledDate;
  String? subtotalAmount;
  String? taxAmount;
  String? totalAmount;
  String? paymentMethod;
  dynamic notes;
  DateTime? fulfilledAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  User? user;

  Bookings({
    this.id,
    this.reference,
    this.status,
    this.paymentStatus,
    this.addressId,
    this.userId,
    this.businessId,
    this.scheduledDate,
    this.subtotalAmount,
    this.taxAmount,
    this.totalAmount,
    this.paymentMethod,
    this.notes,
    this.fulfilledAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) => Bookings(
    id: json["id"],
    reference: json["reference"],
    status: json["status"],
    paymentStatus: json["payment_status"],
    addressId: json["address_id"],
    userId: json["user_id"],
    businessId: json["business_id"],
    scheduledDate: json["scheduled_date"] == null ? null : DateTime.parse(json["scheduled_date"]),
    subtotalAmount: json["subtotal_amount"],
    taxAmount: json["tax_amount"],
    totalAmount: json["total_amount"],
    paymentMethod: json["payment_method"],
    notes: json["notes"],
    fulfilledAt: json["fulfilled_at"] == null ? null : DateTime.parse(json["fulfilled_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "reference": reference,
    "status": status,
    "payment_status": paymentStatus,
    "address_id": addressId,
    "user_id": userId,
    "business_id": businessId,
    "scheduled_date": scheduledDate?.toIso8601String(),
    "subtotal_amount": subtotalAmount,
    "tax_amount": taxAmount,
    "total_amount": totalAmount,
    "payment_method": paymentMethod,
    "notes": notes,
    "fulfilled_at": fulfilledAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? coverImage;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.coverImage,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    coverImage: json["cover_image"],
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
    "cover_image": coverImage,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
