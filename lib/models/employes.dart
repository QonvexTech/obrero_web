import 'package:uitemplate/models/project_model.dart';

import 'message.dart';

class Employees {
  final int id;
  final String fname;
  final String email;
  final String country;
  final String state;
  final String refCode;
  final String city;
  final String phoneNum;
  final List<ProjectModel> projectAssign;
  final bool working;
  final bool onPiremeter;
  final DateTime timeIn;
  final DateTime timeOut;
  final List<Message> inbox;

  Employees(
      this.id,
      this.fname,
      this.email,
      this.country,
      this.state,
      this.refCode,
      this.city,
      this.phoneNum,
      this.projectAssign,
      this.working,
      this.onPiremeter,
      this.timeIn,
      this.timeOut,
      this.inbox);
}
