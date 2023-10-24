

class AddProductToCategoryResponse {
  String? status;
  String? message;
  Data? data;

  AddProductToCategoryResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AddProductToCategoryResponse.fromJson(Map<String, dynamic> json) => AddProductToCategoryResponse(
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
  String? description;
  String? price;
  String? image;
  bool? inStock;
  String? categoryId;
  int? shopId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.name,
    this.description,
    this.price,
    this.image,
    this.inStock,
    this.categoryId,
    this.shopId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    description: json["description"],
    price: json["price"],
    image: json["image"],
    inStock: json["in_stock"],
    categoryId: json["category_id"],
    shopId: json["shop_id"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "image": image,
    "in_stock": inStock,
    "category_id": categoryId,
    "shop_id": shopId,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
