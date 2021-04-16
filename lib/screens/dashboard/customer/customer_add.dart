import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/services/autentication.dart';
import 'package:uitemplate/services/customer_service.dart';

class CustomerAdd extends StatefulWidget {
  final CustomerModel? customerToEdit;

  const CustomerAdd({Key? key, this.customerToEdit}) : super(key: key);
  @override
  _CustomerAddState createState() => _CustomerAddState();
}

class _CustomerAddState extends State<CustomerAdd> {
  bool isEdit = false;
  //TODO: complete the fields
  // String? adress;
  // String? picture;
  // List? customerProjects;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  // TextEditingController countryController = TextEditingController();
  // TextEditingController stateController = TextEditingController();
  // TextEditingController cityController = TextEditingController();
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
    Admin admin = Provider.of<Authentication>(context, listen: false).data;

    var customerService = Provider.of<CustomerService>(context, listen: false);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - (size.width * .5),
      height: size.height / 2,
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
              // Row(
              //   children: [

              //     SizedBox(
              //       width: MySpacer.large,
              //     ),
              //     Expanded(
              //       child: TextField(
              //         decoration: InputDecoration(
              //           hintText: "State",
              //           border: OutlineInputBorder(),
              //         ),
              //         controller: addressController,
              //       ),
              //     ),
              //     SizedBox(
              //       width: MySpacer.large,
              //     ),
              //     Expanded(
              //       child: TextField(
              //         decoration: InputDecoration(
              //           hintText: "City",
              //           border: OutlineInputBorder(),
              //         ),
              //         controller: addressController,
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: MySpacer.large,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: TextField(
              //         decoration: InputDecoration(
              //           hintText: "Démarrer",
              //           border: OutlineInputBorder(),
              //         ),
              //         controller: addressController,
              //       ),
              //     ),
              //     SizedBox(
              //       width: MySpacer.large,
              //     ),
              //     Expanded(
              //       child: TextField(
              //         decoration: InputDecoration(
              //           hintText: "Terminer",
              //           border: OutlineInputBorder(),
              //         ),
              //         controller: addressController,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ))),

          // const SizedBox(
          //   height: MySpacer.small,
          // ),

          MaterialButton(
            height: 60,
            minWidth: double.infinity,
            color: Palette.drawerColor,
            onPressed: () {
              if (isEdit) {
                widget.customerToEdit!.fname = fnameController.text;
                widget.customerToEdit!.lname = lnameController.text;
                widget.customerToEdit!.email = emailController.text;
                widget.customerToEdit!.adress = addressController.text;
                widget.customerToEdit!.picture = "pic";
                widget.customerToEdit!.contactNumber =
                    contactNumberController.text;
                widget.customerToEdit!.amount =
                    double.parse(amountController.text);

                customerService
                    .updateCustomer(
                      editCustomer: widget.customerToEdit!,
                    )
                    .whenComplete(() => Navigator.pop(context));
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

          //TODO: dropdown client
          //TODO: map or coordinates
          // TODO: warnigs
          // TODO:Start date/end
        ],
      )),
    );
  }
}
