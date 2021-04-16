import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/screens/dashboard/customer/customer_list.dart';
import 'package:uitemplate/services/autentication.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';

class CustomerService extends ChangeNotifier {
  Widget activePageScreen = CustomerList(); //change to list adfter
  List<CustomerModel> _customers = [];
  int _page = 1;
  int? _lastPage;
  int? perPage = 10;
  Map bodyToUpdate = {};
  PaginationService? paginationService;

  get customers => _customers;
  get lastPage => _lastPage;

  void setPage(Widget page) {
    activePageScreen = page;
    notifyListeners();
  }

  // void edit(EmployeesModel userToEdit) {
  //   bodyToUpdate.addAll({"user_id": userToEdit.id.toString()});
  //   print(bodyToUpdate);
  //   employeeService.updateUser(body: bodyToUpdate).whenComplete(() {
  //     setState(() {
  //       widget.userToEdit!.fname = fnameController.text;
  //       widget.userToEdit!.lname = lnameController.text;
  //       widget.userToEdit!.email = emailController.text;
  //       widget.userToEdit!.address = addressController.text;
  //       widget.userToEdit!.contactNumber = contactNumberController.text;
  //     });
  //     Navigator.pop(context);
  //   });
  // }

  fromJsonListToCustomer(List customers) {
    List<CustomerModel> newCustomers = [];

    for (var customer in customers) {
      newCustomers.add(CustomerModel.fromJson(customer));
    }
    _customers = newCustomers;
    notifyListeners();
  }

  Future fetchCustomers() async {
    var url =
        Uri.parse("$customer_api${paginationService!.perPage}?page=$_page");
    // final prefs = await SharedPreferences.getInstance();
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${Authentication.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
        List data = json.decode(response.body)["data"];
        if (json.decode(response.body)["next_page_url"] != null) {
          paginationService!.isNext = true;
          notifyListeners();
        }
        if (json.decode(response.body)["prev_page_url"] != null) {
          paginationService!.isPrev = true;
          notifyListeners();
        }
        if (json.decode(response.body)["last_page"] != null) {
          _lastPage = json.decode(response.body)["last_page"];
          print(lastPage);
          notifyListeners();
        }

        fromJsonListToCustomer(data);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future createCustomer({required CustomerModel newCustomer}) async {
    var url = Uri.parse("$customer_create_api");
    try {
      await http.post(url, body: newCustomer.toPayload(), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${Authentication.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        fetchCustomers();
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future removeCustomer({required int id}) async {
    var url = Uri.parse("$customer_delete_api/$id");
    try {
      await http.delete(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${Authentication.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        _customers.removeWhere((element) => element.id == id);
        notifyListeners();
        if (_customers.length == 0) {
          if (paginationService!.getPrev) {
            paginationService!.prevPage(fetchCustomers);
          }
        }
        var data = json.decode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateCustomer({required CustomerModel editCustomer}) async {
    var url = Uri.parse("$customer_update_api");
    try {
      await http.put(url, body: editCustomer.toEdit(), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer " + Authentication.token,
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        notifyListeners();
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }
}
