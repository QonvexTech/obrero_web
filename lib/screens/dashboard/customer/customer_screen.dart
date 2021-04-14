import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/customer_service.dart';

class Customer extends StatefulWidget {
  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  @override
  Widget build(BuildContext context) {
    CustomerService customerService = Provider.of<CustomerService>(context);
    return customerService.activePageScreen;
  }
}
