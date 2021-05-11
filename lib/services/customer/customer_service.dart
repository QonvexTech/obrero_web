import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/models/pagination_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/customer/customer_list.dart';
import 'package:uitemplate/view/dashboard/project/project_list.dart';

class CustomerService extends ChangeNotifier {
  Widget activePageScreen = CustomerList();
  // BuildContext? fromContext;
  PaginationService paginationService = PaginationService();
  TextEditingController searchController = TextEditingController();
  List<CustomerModel>? _customers;
  List<CustomerModel>? _tempCustomer;
  List<ProjectModel>? customerProject;

  late PaginationModel _pagination =
      PaginationModel(lastPage: 1, fetch: fetchCustomers);
  Map bodyToUpdate = {};

  //SEARCH CUSTOMER
  void search(String text) {
    _customers = _tempCustomer;
    _customers = _customers!
        .where((element) =>
            "${element.fname!} ${element.lname!}"
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            // element.lname!.toLowerCase().contains(text.toLowerCase()) ||
            element.adress!.toLowerCase().contains(text.toLowerCase()) ||
            element.email!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    notifyListeners();
  }

  // get fromPage => _fromPage;
  // set fromPage(value) {
  //   _fromPage = value;
  //   notifyListeners();
  // }

  get customers => _customers;
  get pagination => _pagination;

  setPage({required Widget page}) {
    print("object");
    activePageScreen = page;
    notifyListeners();
  }

//IMAGES
  Uint8List? _base64Image;
  get base64Image => _base64Image;
  get base64ImageEncoded => base64.encode(base64Image.toList());
  set base64Image(value) {
    _base64Image = value;
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

  Future workingProjectsCustomer(int customerId) async {
    try {
      var url = Uri.parse("$customer_projects$customerId");
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        if (data["projects"] != null) {
          var tempCustomerProject =
              ProjectModel.fromJsonListToProject(data["projects"]);
          customerProject = await tempCustomerProject;
        } else {
          customerProject = [];
        }

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  fromJsonListToCustomer(List customers) {
    List<CustomerModel> newCustomers = [];
    for (var customer in customers) {
      newCustomers.add(CustomerModel.fromJson(customer));
    }
    _customers = newCustomers;
    _tempCustomer = newCustomers;

    if (_customers!.length == 0) {
      if (_pagination.isPrev) {
        if (_customers!.length == 0) {
          if (_pagination.isPrev) {
            paginationService.prevPage(_pagination);
          }
        }
      }
    }
    searchController.clear();
  }

  Future fetchCustomers() async {
    var url = Uri.parse(
        "$customer_api${_pagination.perPage}?page=${_pagination.page}");
    // final prefs = await SharedPreferences.getInstance();
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        // print(response.body);
        List data = json.decode(response.body)["data"];
        if (json.decode(response.body)["next_page_url"] != null) {
          _pagination.isNext = true;
        }
        if (json.decode(response.body)["prev_page_url"] != null) {
          _pagination.isPrev = true;
        }
        if (json.decode(response.body)["last_page"] != null) {
          _pagination.lastPage = json.decode(response.body)["last_page"];
        }
        _pagination.totalEntries = json.decode(response.body)["total"];
        if (_pagination.totalEntries < _pagination.perPage) {
          _pagination.perPage = _pagination.totalEntries;
        }
        fromJsonListToCustomer(data);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future createCustomer({required CustomerModel newCustomer}) async {
    var url = Uri.parse("$customer_create_api");
    try {
      await http.post(url, body: newCustomer.toPayload(), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        print(data);
        paginationService.addedItem(_pagination);
        fetchCustomers();
        notifyListeners();
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
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        _customers!.removeWhere((element) => element.id == id);

        if (_customers!.length == 0) {
          if (_pagination.isPrev) {
            paginationService.prevPage(_pagination);
          }
        }
        paginationService.removeItem(_pagination);
        notifyListeners();
        var data = json.decode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future updateCustomer({required Map bodyToEdit}) async {
    var url = Uri.parse("$customer_update_api");
    try {
      await http.put(url, body: bodyToEdit, headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        fetchCustomers();
        print(data);
        print("update success");
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }
}
