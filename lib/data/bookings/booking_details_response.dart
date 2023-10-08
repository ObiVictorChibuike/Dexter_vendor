

class BookingDetailsResponse {
  String? status;
  String? message;
  Data? data;

  BookingDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BookingDetailsResponse.fromJson(Map<String, dynamic> json) => BookingDetailsResponse(
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
  dynamic paymentMethod;
  String? notes;
  dynamic fulfilledAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  User? user;
  Address? address;

  Data({
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
    this.address,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    fulfilledAt: json["fulfilled_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
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
    "fulfilled_at": fulfilledAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "user": user?.toJson(),
    "address": address?.toJson(),
  };
}

class Address {
  int? id;
  int? userId;
  String? street;
  String? city;
  String? state;
  String? country;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? fullAddress;

  Address({
    this.id,
    this.userId,
    this.street,
    this.city,
    this.state,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.fullAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    userId: json["user_id"],
    street: json["street"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    fullAddress: json["full_address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "street": street,
    "city": city,
    "state": state,
    "country": country,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "full_address": fullAddress,
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
