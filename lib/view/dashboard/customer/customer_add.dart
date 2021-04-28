import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/services/customer_service.dart';

class CustomerAdd extends StatefulWidget {
  final CustomerModel? customerToEdit;

  const CustomerAdd({Key? key, this.customerToEdit}) : super(key: key);
  @override
  _CustomerAddState createState() => _CustomerAddState();
}

class _CustomerAddState extends State<CustomerAdd> {
  bool isEdit = false;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    if (widget.customerToEdit != null) {
      fnameController.text = widget.customerToEdit!.fname!;
      lnameController.text = widget.customerToEdit!.lname!;
      emailController.text = widget.customerToEdit!.email!;
      addressController.text = widget.customerToEdit!.adress!;
      contactNumberController.text = widget.customerToEdit!.contactNumber!;
      amountController.text = widget.customerToEdit!.status!.amount!.toString();
      isEdit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var customerService = Provider.of<CustomerService>(context, listen: false);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      constraints: BoxConstraints(maxWidth: 800, maxHeight: size.height / 1.8),
      padding: EdgeInsets.all(20),
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Scrollbar(
                  child: ListView(
            children: [
              Text(
                "Ajouter un Client",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MySpacer.large,
              ),
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: "Prénom",
                    border: OutlineInputBorder(),
                    hintStyle: transHeader),
                controller: fnameController,
              ),
              SizedBox(
                height: MySpacer.small,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Nom de famillie",
                  hintStyle: transHeader,
                  border: OutlineInputBorder(),
                ),
                controller: lnameController,
              ),
              SizedBox(
                height: MySpacer.small,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
              ),
              SizedBox(
                height: MySpacer.small,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Téléphone",
                  border: OutlineInputBorder(),
                ),
                controller: contactNumberController,
              ),
              SizedBox(
                height: MySpacer.small,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Address",
                  border: OutlineInputBorder(),
                ),
                controller: addressController,
              ),
              SizedBox(
                height: MySpacer.small,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "Amount",
                  border: OutlineInputBorder(),
                ),
                controller: amountController,
              ),
            ],
          ))),
          MaterialButton(
            height: 60,
            minWidth: double.infinity,
            color: Palette.drawerColor,
            onPressed: () {
              if (isEdit) {
              } else {
                CustomerModel newCustomer = CustomerModel(
                    fname: fnameController.text,
                    lname: lnameController.text,
                    email: emailController.text,
                    adress: addressController.text,
                    picture: "pic",
                    contactNumber: contactNumberController.text,
                    amount: double.parse(amountController.text));

                customerService
                    .createCustomer(newCustomer: newCustomer)
                    .whenComplete(() => Navigator.pop(context));
              }
            },
            child: Text(
              isEdit ? "Save Edit" : "Caréer",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      )),
    );
  }
}
