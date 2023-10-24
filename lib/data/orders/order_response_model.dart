
class OrderResponseModel {
  String? status;
  String? message;
  List<Orders>? data;

  OrderResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) => OrderResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Orders>.from(json["data"]!.map((x) => Orders.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Orders {
  int? id;
  String? reference;
  String? status;
  String? paymentStatus;
  int? addressId;
  int? userId;
  int? shopId;
  String? subtotalAmount;
  String? discountAmount;
  String? taxAmount;
  String? totalAmount;
  String? shippingCost;
  dynamic additionalCharge;
  String? notes;
  dynamic paymentMethod;
  dynamic fulfilledAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  User? user;

  Orders({
    this.id,
    this.reference,
    this.status,
    this.paymentStatus,
    this.addressId,
    this.userId,
    this.shopId,
    this.subtotalAmount,
    this.discountAmount,
    this.taxAmount,
    this.totalAmount,
    this.shippingCost,
    this.additionalCharge,
    this.notes,
    this.paymentMethod,
    this.fulfilledAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    id: json["id"],
    reference: json["reference"],
    status: json["status"],
    paymentStatus: json["payment_status"],
    addressId: json["address_id"],
    userId: json["user_id"],
    shopId: json["shop_id"],
    subtotalAmount: json["subtotal_amount"],
    discountAmount: json["discount_amount"],
    taxAmount: json["tax_amount"],
    totalAmount: json["total_amount"],
    shippingCost: json["shipping_cost"],
    additionalCharge: json["additional_charge"],
    notes: json["notes"],
    paymentMethod: json["payment_method"],
    fulfilledAt: json["fulfilled_at"],
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
    "shop_id": shopId,
    "subtotal_amount": subtotalAmount,
    "discount_amount": discountAmount,
    "tax_amount": taxAmount,
    "total_amount": totalAmount,
    "shipping_cost": shippingCost,
    "additional_charge": additionalCharge,
    "notes": notes,
    "payment_method": paymentMethod,
    "fulfilled_at": fulfilledAt,
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
