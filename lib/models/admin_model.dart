class Admin {
  int? id;
  String? token;
  String? firstName;
  String? lastName;
  String? contacNumber;
  String? address;
  String? email;
  String? picture;
  DateTime? createdAt;
  DateTime? updatedAt;

  Admin(
      {this.id,
      this.token,
      this.firstName,
      this.lastName,
      this.contacNumber,
      this.address,
      this.email,
      this.picture,
      this.createdAt,
      this.updatedAt});

  Admin.fromJson(Map<String, dynamic> json) {
    this.token = json["token"];
    this.id = json["details"]["id"];
    this.firstName = json["details"]["first_name"];
    this.lastName = json["details"]["last_name"];
    this.contacNumber = json["details"]["contact_number"];
    this.address = json["details"]["address"];
    this.email = json["details"]["email"];
    this.picture = json["details"]["picture"];
    this.createdAt = json["details"]["created_at"] != null
        ? DateTime.parse(json["details"]["created_at"])
        : null;
    this.updatedAt = json["details"]["updated_at"] != null
        ? DateTime.parse(json["details"]["updated_at"])
        : null;
  }
  Admin.fromJsonUpdate(Map<String, dynamic> json) {
    this.id = json["id"];
    this.firstName = json["first_name"];
    this.lastName = json["last_name"];
    this.contacNumber = json["contact_number"];
    this.address = json["address"];
    this.email = json["email"];
    this.picture = json["picture"];
  }

  //   Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data["name"] = budgetName.toString();
  //   data["initial_budget"] = initialBudget.toString();
  //   data["first_day_period"] = startDate.toString();
  //   data["period_type"] = periodType.toString();
  //   data["purpose"] = purpose.toString();
  //   data["currency_id"] = currencyId.toString();
  //   data["today_budget"] = dayBudget.toString();
  //   data["week_budget"] = weekBudget.toString();
  //   data["end_date"] = endDate.toString();
  //   return data;
  // }
}
