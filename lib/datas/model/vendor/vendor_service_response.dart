
class GetServicesResponse {
  GetServicesResponse({
    this.id,
    this.name,
    this.description,
  });

  int? id;
  String? name;
  String? description;

  factory GetServicesResponse.fromJson(Map<String, dynamic> json) => GetServicesResponse(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}
