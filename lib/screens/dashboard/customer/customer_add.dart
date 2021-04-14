import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/services/customer_service.dart';

class CustomerAdd extends StatefulWidget {
  @override
  _CustomerAddState createState() => _CustomerAddState();
}

class _CustomerAddState extends State<CustomerAdd> {
  //TODO: complete the fields
  // String? adress;
  // String? picture;
  // List? customerProjects;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var customerService = Provider.of<CustomerService>(context, listen: false);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - (size.width * .2),
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
              Text('dolo ep sulon'),
              SizedBox(
                height: MySpacer.large,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: "Prénom",
                          border: OutlineInputBorder(),
                          hintStyle: transHeader),
                      controller: fnameController,
                    ),
                  ),
                  SizedBox(
                    width: MySpacer.large,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Nom de famillie",
                        hintStyle: transHeader,
                        border: OutlineInputBorder(),
                      ),
                      controller: lnameController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MySpacer.large,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      controller: emailController,
                    ),
                  ),
                  SizedBox(
                    width: MySpacer.large,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Téléphone",
                        border: OutlineInputBorder(),
                      ),
                      controller: contactNumberController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MySpacer.large,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Country",
                        border: OutlineInputBorder(),
                      ),
                      controller: addressController,
                    ),
                  ),
                  SizedBox(
                    width: MySpacer.large,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "State",
                        border: OutlineInputBorder(),
                      ),
                      controller: addressController,
                    ),
                  ),
                  SizedBox(
                    width: MySpacer.large,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "City",
                        border: OutlineInputBorder(),
                      ),
                      controller: addressController,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MySpacer.large,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Démarrer",
                        border: OutlineInputBorder(),
                      ),
                      controller: addressController,
                    ),
                  ),
                  SizedBox(
                    width: MySpacer.large,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Terminer",
                        border: OutlineInputBorder(),
                      ),
                      controller: addressController,
                    ),
                  ),
                ],
              ),
            ],
          ))),

          const SizedBox(
            height: MySpacer.small,
          ),

          MaterialButton(
            height: 60,
            minWidth: double.infinity,
            color: Palette.drawerColor,
            onPressed: () {
              CustomerModel newCustomer = CustomerModel(
                  fname: fnameController.text,
                  lname: lnameController.text,
                  email: emailController.text,
                  adress: addressController.text,
                  picture: "pic",
                  contactNumber: contactNumberController.text,
                  amount: double.parse(amountController.text));

              customerService.createCustomer(newCustomer);
            },
            child: Text(
              "Caréer",
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
