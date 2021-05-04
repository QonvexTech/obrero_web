import 'package:uitemplate/models/payment_model.dart';

class CustomerModel {
  int? id;
  String? fname;
  String? lname;
  String? email;
  String? adress;
  String? picture;
  PaymentModel? status;
  String? contactNumber;
  List? customerProjects;
  double? amount;
  bool isSelected = false;

  CustomerModel(
      {this.id,
      this.fname,
      this.lname,
      this.email,
      this.adress,
      this.picture,
      this.contactNumber,
      this.customerProjects,
      this.amount,
      this.status});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.fname = json["first_name"];
    this.lname = json["last_name"];
    this.email = json["email"];
    this.adress = json["address"];
    this.picture = json["picture"] ?? "";
    this.status = json["status"] != null
        ? PaymentModel.fromJson(json["status"])
        : PaymentModel();
    this.contactNumber = json["contact_number"];
    this.customerProjects = json["projects"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["first_name"] = this.fname;
    data["last_name"] = this.lname;
    data["email"] = this.email;
    data["address"] = this.adress;
    data["picture"] = this.picture.toString();
    data["status"] = this.status.toString();
    data["contact_number"] = this.contactNumber;
    data["projects"] = this.customerProjects.toString();
    return data;
  }

  Map<String, dynamic> toEdit() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id.toString();
    data["first_name"] = this.fname;
    data["last_name"] = this.lname;
    data["email"] = this.email;
    data["address"] = this.adress;
    data["picture"] = "data:image/jpg;base64,${this.picture}";
    // data["status"] = this.status.toString();
    data["contact_number"] = this.contactNumber;
    return data;
  }

  Map<String, dynamic> toPayload() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["first_name"] = this.fname;
    data["last_name"] = this.lname;
    data["email"] = this.email;
    data["address"] = this.adress;
    print("PICTURE : ${this.picture}");
    data["picture"] = "data:image/jpg;base64,${this.picture}";
    // data["status"] = this.status;
    data["contact_number"] = this.contactNumber;
    data["amount"] = this.amount.toString();
    return data;
  }
}
