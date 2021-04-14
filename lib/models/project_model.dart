class ProjectModel {
  int? id;
  int? customerId;
  String? name;
  String? description;
  List? coordinates;
  List? warnings;
  DateTime? startDate;
  DateTime? endDate;

  ProjectModel(
      {this.id,
      required this.customerId,
      required this.name,
      this.description,
      required this.coordinates,
      this.warnings,
      required this.startDate,
      required this.endDate});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.name = json["name"];
    this.customerId = json["customer_id"];
    this.coordinates = json["coordinates"] != null
        ? json["coordinates"].toString().split(",").toList()
        : [];
    this.description = json["description"];

    this.startDate =
        json["start_date"] != null ? DateTime.parse(json["start_date"]) : null;
    this.endDate =
        json["end_date"] != null ? DateTime.parse(json["end_date"]) : null;
    this.warnings = json["warnings"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name.toString();
    data["customer_id"] = this.customerId.toString();
    data["coordinates"] = "${this.coordinates![0]}, ${this.coordinates![1]}";
    data["description"] = this.description;
    data["start_date"] = this.startDate!.toString();
    data["end_date"] = this.endDate!.toString();
    return data;
  }
}
