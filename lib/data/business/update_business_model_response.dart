
class UpdateBusinessResponseModel {
  String? status;
  String? message;
  Data? data;

  UpdateBusinessResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UpdateBusinessResponseModel.fromJson(Map<String, dynamic> json) => UpdateBusinessResponseModel(
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

  Data({
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
