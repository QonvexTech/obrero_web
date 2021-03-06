import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/models/pagination_model.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/customer/customer_list.dart';

class CustomerService extends ChangeNotifier {
  Widget activePageScreen = CustomerList();
  PaginationService paginationService = PaginationService();
  List<CustomerModel> _customers = [];
  List<CustomerModel> _tempCustomer = [];
  int _totalEntries = 0;
  late PaginationModel _pagination = PaginationModel(
      lastPage: 1, fetch: fetchCustomers, totalEntries: _totalEntries);
  Map bodyToUpdate = {};

  TextEditingController _searchController = TextEditingController();

  get searchController => _searchController;

  get customers => _customers;
  get pagination => _pagination;
  void setPage(Widget page) {
    activePageScreen = page;
    notifyListeners();
  }

  void search(String text) {
    _customers = _customers
        .where((element) =>
            element.fname!.toLowerCase().contains(text.toLowerCase()) ||
            element.email!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    if (text.isEmpty) {
      _customers = _tempCustomer;
    }
    notifyListeners();
  }

  fromJsonListToCustomer(List customers) {
    List<CustomerModel> newCustomers = [];
    for (var customer in customers) {
      newCustomers.add(CustomerModel.fromJson(customer));
    }
    _customers = newCustomers;
    _tempCustomer = newCustomers;
    _searchController.clear();
    notifyListeners();
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
        print(json.decode(response.body));
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
        "Authorization": "Bearer $authToken",
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
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        _customers.removeWhere((element) => element.id == id);
        notifyListeners();
        if (_customers.length == 0) {
          if (_pagination.isPrev) {
            paginationService.prevPage(_pagination);
          }
        }
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
        notifyListeners();
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }
}
