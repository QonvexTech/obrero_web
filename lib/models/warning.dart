class WarningModel {
  int? id;
  int? userId;
  int? projectId;
  String? title;
  String? description;
  int? type;
  String? picture;
  String? createdAt;

  WarningModel(this.id, this.userId, this.projectId, this.title,
      this.description, this.type, this.picture, this.createdAt);

  WarningModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.userId = json["user_id"];
    this.projectId = json["project_id"];
    this.title = json["title"];
    this.description = json["description"];
    this.type = json["type"];
    this.picture = json["picture"];
    this.createdAt = json["created_at"];
  }

  static List<WarningModel> fromJsonListToWarningsModel(List warnings) {
    List<WarningModel> newWarnings = [];
    for (var warning in warnings) {
      WarningModel userModel = WarningModel.fromJson(warning);

      newWarnings.add(userModel);
    }
    return newWarnings;
  }
}
