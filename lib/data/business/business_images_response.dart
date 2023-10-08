

class BusinessImagesResponseModel {
  String? status;
  String? message;
  List<BusinessImages>? data;

  BusinessImagesResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory BusinessImagesResponseModel.fromJson(Map<String, dynamic> json) => BusinessImagesResponseModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<BusinessImages>.from(json["data"]!.map((x) => BusinessImages.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class BusinessImages {
  int? id;
  int? businessId;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  BusinessImages({
    this.id,
    this.businessId,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory BusinessImages.fromJson(Map<String, dynamic> json) => BusinessImages(
    id: json["id"],
    businessId: json["business_id"],
    imageUrl: json["image_url"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_id": businessId,
    "image_url": imageUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
