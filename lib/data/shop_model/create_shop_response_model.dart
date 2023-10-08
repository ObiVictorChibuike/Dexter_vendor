
class CreateShopResponse {
  String? status;
  String? message;
  Data? data;

  CreateShopResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreateShopResponse.fromJson(Map<String, dynamic> json) => CreateShopResponse(
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
  String? name;
  String? biography;
  String? coverImage;
  String? openingTime;
  String? closingTime;
  ContactAddress? contactAddress;
  String? contactEmail;
  String? contactPhone;
  String? discount;
  String? shippingCost;
  String? longitude;
  String? latitude;
  // int? serviceId;
  dynamic serviceId;
  int? vendorId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.name,
    this.biography,
    this.coverImage,
    this.openingTime,
    this.closingTime,
    this.contactAddress,
    this.contactEmail,
    this.contactPhone,
    this.discount,
    this.shippingCost,
    this.longitude,
    this.latitude,
    this.serviceId,
    this.vendorId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    biography: json["biography"],
    coverImage: json["cover_image"],
    openingTime: json["opening_time"],
    closingTime: json["closing_time"],
    contactAddress: json["contact_address"] == null ? null : ContactAddress.fromJson(json["contact_address"]),
    contactEmail: json["contact_email"],
    contactPhone: json["contact_phone"],
    discount: json["discount"],
    shippingCost: json["shipping_cost"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    serviceId: json["service_id"],
    vendorId: json["vendor_id"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "biography": biography,
    "cover_image": coverImage,
    "opening_time": openingTime,
    "closing_time": closingTime,
    "contact_address": contactAddress?.toJson(),
    "contact_email": contactEmail,
    "contact_phone": contactPhone,
    "discount": discount,
    "shipping_cost": shippingCost,
    "longitude": longitude,
    "latitude": latitude,
    "service_id": serviceId,
    "vendor_id": vendorId,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
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
