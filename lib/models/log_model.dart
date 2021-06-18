class LogModel {
  int? id;
  String? title;
  String? body;
  int? sender_id;
  int? seen;
  int? data_id;
  String? type;
  String? created_at;
  LogModel(
      {required this.id,
      required this.title,
      required this.body,
      required this.sender_id,
      required this.seen,
      required this.data_id,
      required this.type,
      required this.created_at});
  LogModel.fromJson(Map<String, dynamic> json) {
    print("NOTES : $json");
    this.id = json["id"];
    this.title = json["title"];
    this.body = json["body"];
    this.sender_id =
        json["sender_details"] != null ? json["sender_details"]["id"] : null;
    this.seen = json["seen"];
    this.data_id = json["data_id"];
    this.type = json["type"];
    this.created_at = json['created_at'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["title"] = this.title;
    data["body"] = this.body;
    data["sender_id"] = this.sender_id;
    data["seen"] = this.seen;
    data["data_id"] = this.data_id;
    data["type"] = this.type;
    data['created_at'] = this.created_at;
    return data;
  }
}
