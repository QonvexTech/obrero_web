import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/models/pagination_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/customer/customer_list.dart';

class CustomerService extends ChangeNotifier {
  Widget activePageScreen = CustomerList();

  bool _loader = false;

  // BuildContext? fromContext;
  PaginationService paginationService = PaginationService();
  TextEditingController searchController = TextEditingController();
  List<CustomerModel>? _customers;
  List<CustomerModel> _customersLoad = [];
  List<CustomerModel> _tempCustomersLoad = [];
  List<CustomerModel>? _tempCustomer;
  List<ProjectModel>? customerProject;

  late PaginationModel _pagination =
      PaginationModel(lastPage: 1, fetch: fetchCustomers);

  late PaginationModel _paginationLoad =
      PaginationModel(lastPage: 1, fetch: loadMore);

  Map bodyToUpdate = {};

  get loader => _loader;
  set loader(value) {
    _loader = value;
    notifyListeners();
  }

  //SEARCH CUSTOMER
  Future<List<CustomerModel>> search(String text) async {
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
    return _customers!;
  }

  Future<List<CustomerModel>> searchLoad(String text) async {
    if (text.isEmpty) {
      _customersLoad = _tempCustomersLoad;
    } else {
      print("empty");
      _customersLoad = _customersLoad
          .where((element) =>
              "${element.fname!} ${element.lname!}"
                  .toLowerCase()
                  .contains(text.toLowerCase()) ||
              element.lname!.toLowerCase().contains(text.toLowerCase()) ||
              element.adress!.toLowerCase().contains(text.toLowerCase()) ||
              element.email!.toLowerCase().contains(text.toLowerCase()))
          .toList();

      while (_paginationLoad.isNext) {
        _paginationLoad.page += 1;
        _paginationLoad.isNext = false;
        load(false);
        _customersLoad = _customersLoad
            .where((element) =>
                "${element.fname!} ${element.lname!}"
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.lname!.toLowerCase().contains(text.toLowerCase()) ||
                element.adress!.toLowerCase().contains(text.toLowerCase()) ||
                element.email!.toLowerCase().contains(text.toLowerCase()))
            .toList();
      }
    }
    print("OnSEARCH :$text");
    notifyListeners();
    return _customersLoad;

    // if (_customersLoad.isEmpty && _pagination.isNext) {
    //   loadMore();
    //   _customersLoad = _customersLoad
    //       .where((element) =>
    //           "${element.fname!} ${element.lname!}"
    //               .toLowerCase()
    //               .contains(text.toLowerCase()) ||
    //           // element.lname!.toLowerCase().contains(text.toLowerCase()) ||
    //           element.adress!.toLowerCase().contains(text.toLowerCase()) ||
    //           element.email!.toLowerCase().contains(text.toLowerCase()))
    //       .toList();
    // }
  }

  // get fromPage => _fromPage;
  // set fromPage(value) {
  //   _fromPage = value;
  //   notifyListeners();
  // }

  get customers => _customers;
  get customersLoad => _customersLoad;

  get pagination => _pagination;
  get paginationLoad => _paginationLoad;

  void loadMore() {
    if (_paginationLoad.isNext) {
      _paginationLoad.page += 1;
      load(false);
    }
  }

  void initLoad() {
    _customersLoad = [];
    _tempCustomersLoad = [];
    _paginationLoad.page = 1;
    load(true);
  }

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
          await ProjectModel.fromJsonListToProject(data["projects"])
              .then((value) {
            customerProject = value;

            notifyListeners();
          });
          if (customerProject == null) {
            customerProject = [];
          }
        } else {
          customerProject = [];
        }
        print("customerproject: ${customerProject!.length}");
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

    if (newCustomers.length == 0) {
      if (_pagination.isPrev) {
        if (newCustomers.length == 0) {
          if (_pagination.isPrev) {
            paginationService.prevPage(_pagination);
          }
        }
      }
    }
    newCustomers.reversed;
    return newCustomers;
  }

  Future fetchCustomers() async {
    _loader = true;
    print("Fetching...");
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
        print(response.body);
        if (json.decode(response.body)["next_page_url"] != null) {
          _pagination.isNext = true;
          print("NEXT is ${_pagination.isNext}");
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
        var newCustomers = fromJsonListToCustomer(data);
        _customers = newCustomers;
        _tempCustomer = newCustomers;

        print(data);

        searchController.clear();
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    _loader = false;
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

  Future<bool> updateCustomer({required Map bodyToEdit}) async {
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

        if (data["data"]["original"] != null) {
          Fluttertoast.showToast(
              webBgColor: "linear-gradient(to right, #E21010, #ED9393)",
              msg: "Email has already been taken",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              fontSize: 16.0);
          return false;
        } else {
          return true;
        }
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future load(bool init) async {
    var url = Uri.parse(
        "$customer_api${_paginationLoad.perPage}?page=${_paginationLoad.page}");
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body)["data"];
        if (json.decode(response.body)["next_page_url"] != null) {
          _paginationLoad.isNext = true;
        } else {
          _paginationLoad.isNext = false;
        }
        if (json.decode(response.body)["prev_page_url"] != null) {
          _paginationLoad.isPrev = true;
        } else {
          _paginationLoad.isPrev = false;
        }
        if (json.decode(response.body)["last_page"] != null) {
          _paginationLoad.lastPage = json.decode(response.body)["last_page"];
        }
        _paginationLoad.totalEntries = json.decode(response.body)["total"];
        if (_paginationLoad.totalEntries < _paginationLoad.perPage) {
          _paginationLoad.perPage = _paginationLoad.totalEntries;
        }
        var newCustomers = fromJsonListToCustomer(data);
        _customersLoad.addAll(newCustomers);
        _tempCustomersLoad.addAll(newCustomers);
        print(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    if (init == false) {
      notifyListeners();
    }
  }
}
