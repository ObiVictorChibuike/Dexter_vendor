

class ProductReviewsResponse {
  String? status;
  String? message;
  List<ProductReview>? data;

  ProductReviewsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ProductReviewsResponse.fromJson(Map<String, dynamic> json) => ProductReviewsResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ProductReview>.from(json["data"]!.map((x) => ProductReview.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ProductReview {
  int? id;
  int? userId;
  String? reviewableType;
  int? reviewableId;
  String? comment;
  int? rating;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  User? user;

  ProductReview({
    this.id,
    this.userId,
    this.reviewableType,
    this.reviewableId,
    this.comment,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
    id: json["id"],
    userId: json["user_id"],
    reviewableType: json["reviewable_type"],
    reviewableId: json["reviewable_id"],
    comment: json["comment"],
    rating: json["rating"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "reviewable_type": reviewableType,
    "reviewable_id": reviewableId,
    "comment": comment,
    "rating": rating,
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
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
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
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
