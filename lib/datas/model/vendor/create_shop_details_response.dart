
class CreateShopDetailsResponse {
  CreateShopDetailsResponse({
    this.success,
    this.message,
    this.existingDetail,
  });

  bool? success;
  String? message;
  ExistingDetail? existingDetail;

  factory CreateShopDetailsResponse.fromJson(Map<String, dynamic> json) => CreateShopDetailsResponse(
    success: json["success"],
    message: json["message"],
    existingDetail: json["Existing detail"] == null ? null : ExistingDetail.fromJson(json["Existing detail"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "Existing detail": existingDetail?.toJson(),
  };
}

class ExistingDetail {
  ExistingDetail({
    this.id,
    this.shopId,
    this.shopName,
    this.shopBio,
    this.discount,
    this.openedFrom,
    this.openedTo,
    this.address,
    this.rating,
    this.vat,
    this.additionalCharge,
    this.deliveryFee,
    this.jobsCompleted,
    this.longitude,
    this.latitude,
  });

  int? id;
  int? shopId;
  String? shopName;
  String? shopBio;
  int? discount;
  String? openedFrom;
  String? openedTo;
  String? address;
  String? rating;
  String? vat;
  String? additionalCharge;
  String? deliveryFee;
  String? jobsCompleted;
  double? longitude;
  double? latitude;

  factory ExistingDetail.fromJson(Map<String, dynamic> json) => ExistingDetail(
    id: json["id"],
    shopId: json["shop_id"],
    shopName: json["shop_name"],
    shopBio: json["shop_bio"],
    discount: json["discount"],
    openedFrom: json["opened_from"],
    openedTo: json["opened_to"],
    address: json["address"],
    rating: json["rating"],
    vat: json["vat"],
    additionalCharge: json["additional_charge"],
    deliveryFee: json["delivery_fee"],
    jobsCompleted: json["jobs_completed"],
    longitude: json["longitude"]?.toDouble(),
    latitude: json["latitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "shop_id": shopId,
    "shop_name": shopName,
    "shop_bio": shopBio,
    "discount": discount,
    "opened_from": openedFrom,
    "opened_to": openedTo,
    "address": address,
    "rating": rating,
    "vat": vat,
    "additional_charge": additionalCharge,
    "delivery_fee": deliveryFee,
    "jobs_completed": jobsCompleted,
    "longitude": longitude,
    "latitude": latitude,
  };
}
