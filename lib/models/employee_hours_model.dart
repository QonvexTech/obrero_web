class EmployeeHourModel {
  int? id;
  String? timeIn;
  String? timeOut;
  String? recordedTime;

  EmployeeHourModel(this.id, this.timeIn, this.timeOut, this.recordedTime);

  EmployeeHourModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.recordedTime = json["recorded_time"];
  }
}
