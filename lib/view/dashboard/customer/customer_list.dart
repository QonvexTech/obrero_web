import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/view/dashboard/customer/customer_add.dart';
import 'package:uitemplate/widgets/headerList.dart';
import 'package:uitemplate/widgets/sample_table.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  @override
  Widget build(BuildContext context) {
    CustomerService customerService = Provider.of<CustomerService>(context);
    return Container(
      color: Palette.contentBackground,
      child: Column(
        children: [
          SizedBox(
            height: MySpacer.medium,
          ),
          HeaderList(toPage: CustomerAdd(), title: "Customer"),
          SizedBox(
            height: MySpacer.large,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: TableExample(),
            ),
          ),
          SizedBox(
            height: MySpacer.large,
          )
        ],
      ),
    );
  }
}
