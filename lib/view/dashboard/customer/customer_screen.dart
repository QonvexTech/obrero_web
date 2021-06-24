import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/customer/customer_service.dart';

class CustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {
      return Provider.of<CustomerService>(context).activePageScreen;
    } catch (e) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Palette.drawerColor),
        ),
      );
    }
  }
}
