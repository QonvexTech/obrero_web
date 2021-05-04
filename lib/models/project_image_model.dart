class ProjectImageModel {
  int? id;
  int? projectId;
  String? url;

  ProjectImageModel(this.id, this.projectId, this.url);

  ProjectImageModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.projectId = json["project_id"];
    this.url = json["url"];
  }

  static List<ProjectImageModel> formListtoImageModel(List images) {
    List<ProjectImageModel> newImages = [];
    for (var user in images) {
      ProjectImageModel userModel = ProjectImageModel.fromJson(user);
      newImages.add(userModel);
    }
    return newImages;
  }
}
