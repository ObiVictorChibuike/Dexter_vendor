
class StoreVendorTypeResponse {
  StoreVendorTypeResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory StoreVendorTypeResponse.fromJson(Map<String, dynamic> json) => StoreVendorTypeResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
