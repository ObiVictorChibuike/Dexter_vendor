

class BankResponse {
  String? status;
  String? message;
  List<Banks>? data;

  BankResponse({
    this.status,
    this.message,
    this.data,
  });

  factory BankResponse.fromJson(Map<String, dynamic> json) => BankResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Banks>.from(json["data"]!.map((x) => Banks.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Banks {
  int? id;
  String? name;
  String? code;
  String? slug;

  Banks({
    this.id,
    this.name,
    this.code,
    this.slug,
  });

  factory Banks.fromJson(Map<String, dynamic> json) => Banks(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "slug": slug,
  };
}
