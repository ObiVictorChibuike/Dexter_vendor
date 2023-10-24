
class LoginResponse {
  String? status;
  String? message;
  Data? data;

  LoginResponse({
    this.status,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
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
  User? user;
  String? token;

  Data({
    this.user,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
  };
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? availableBalance;
  String? image;
  String? qualification;
  dynamic nin;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Business? shop;
  Business? business;

  User({
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
    this.shop,
    this.business,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
    shop: json["shop"] == null ? null : Business.fromJson(json["shop"]),
    business: json["business"] == null ? null : Business.fromJson(json["business"]),
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
    "shop": shop?.toJson(),
    "business": business?.toJson(),
  };
}

class Business {
  int? id;
  String? name;
  String? biography;
  String? coverImage;
  String? openingTime;
  String? closingTime;
  String? contactEmail;
  String? contactPhone;
  String? serviceCharge;
  ContactAddress? contactAddress;
  int? vendorId;
  String? longitude;
  String? latitude;
  int? serviceId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Service? service;
  String? discount;
  String? shippingCost;

  Business({
    this.id,
    this.name,
    this.biography,
    this.coverImage,
    this.openingTime,
    this.closingTime,
    this.contactEmail,
    this.contactPhone,
    this.serviceCharge,
    this.contactAddress,
    this.vendorId,
    this.longitude,
    this.latitude,
    this.serviceId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.service,
    this.discount,
    this.shippingCost,
  });

  factory Business.fromJson(Map<String, dynamic> json) => Business(
    id: json["id"],
    name: json["name"],
    biography: json["biography"],
    coverImage: json["cover_image"],
    openingTime: json["opening_time"],
    closingTime: json["closing_time"],
    contactEmail: json["contact_email"],
    contactPhone: json["contact_phone"],
    serviceCharge: json["service_charge"],
    contactAddress: json["contact_address"] == null ? null : ContactAddress.fromJson(json["contact_address"]),
    vendorId: json["vendor_id"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    serviceId: json["service_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    service: json["service"] == null ? null : Service.fromJson(json["service"]),
    discount: json["discount"],
    shippingCost: json["shipping_cost"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "biography": biography,
    "cover_image": coverImage,
    "opening_time": openingTime,
    "closing_time": closingTime,
    "contact_email": contactEmail,
    "contact_phone": contactPhone,
    "service_charge": serviceCharge,
    "contact_address": contactAddress?.toJson(),
    "vendor_id": vendorId,
    "longitude": longitude,
    "latitude": latitude,
    "service_id": serviceId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "service": service?.toJson(),
    "discount": discount,
    "shipping_cost": shippingCost,
  };
}

class ContactAddress {
  String? street;
  String? city;
  String? state;
  String? country;
  String? fullAddress;

  ContactAddress({
    this.street,
    this.city,
    this.state,
    this.country,
    this.fullAddress,
  });

  factory ContactAddress.fromJson(Map<String, dynamic> json) => ContactAddress(
    street: json["street"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    fullAddress: json["full_address"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "country": country,
    "full_address": fullAddress,
  };
}

class Service {
  int? id;
  String? name;
  bool? isBookable;
  String? description;
  dynamic deletedAt;

  Service({
    this.id,
    this.name,
    this.isBookable,
    this.description,
    this.deletedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
    isBookable: json["is_bookable"],
    description: json["description"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "is_bookable": isBookable,
    "description": description,
    "deleted_at": deletedAt,
  };
}
