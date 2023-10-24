
class AddProductCategoryResponse {
  String? status;
  String? message;
  Data? data;

  AddProductCategoryResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AddProductCategoryResponse.fromJson(Map<String, dynamic> json) => AddProductCategoryResponse(
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
  String? coverImage;
  int? shopId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.name,
    this.coverImage,
    this.shopId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    coverImage: json["cover_image"],
    shopId: json["shop_id"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "cover_image": coverImage,
    "shop_id": shopId,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
