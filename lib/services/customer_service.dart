import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/models/payment_model.dart';
import 'package:uitemplate/screens/dashboard/customer/customer_details.dart';

class CustomerService extends ChangeNotifier {
  //TODO: depend on nextPage check if there is next page exist
  //s
  Widget activePageScreen = CustomerDetails(); //change to list adfter
  List<CustomerModel> _customers = [
    CustomerModel(
        status: PaymentModel(id: 1, status: 0, amount: 100),
        fname: "fname",
        lname: "lname",
        email: "email",
        adress: "adress",
        picture: "picture",
        contactNumber: "contactNumber")
  ];
  int _perPage = 10;
  int _page = 1;

  get customers => _customers;

  void setPage(Widget page) {
    activePageScreen = page;
    notifyListeners();
  }

  set page(value) {
    _page = value;
    fetchCustomers();
  }

  get page => _page;

  fromJsonListToCustomer(List customers) {
    List<CustomerModel> newCustomers = [];

    for (var customer in customers) {
      newCustomers.add(CustomerModel.fromJson(customer));
    }
    _customers = newCustomers;
    notifyListeners();
  }

  Future fetchCustomers() async {
    var url = Uri.parse("$customer_api$_perPage?page=$_page");
    // final prefs = await SharedPreferences.getInstance();
    try {
      var response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body)["data"];
        fromJsonListToCustomer(data);
        print("CUSTOMERS");
        print(data);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future createCustomer(CustomerModel newCustomer) async {
    var url = Uri.parse("$customer_create_api");
    try {
      await http.post(url, body: newCustomer.toPayload()).then((response) {
        var data = json.decode(response.body);
        // fetchCustomers();
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future removeCustomer(int id) async {
    var url = Uri.parse("$customer_delete_api/$id");
    try {
      await http.delete(url, headers: {"accept": "application/json"}).then(
          (response) {
        _customers.removeWhere((element) => element.id == id);
        notifyListeners();
        var data = json.decode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }
}
