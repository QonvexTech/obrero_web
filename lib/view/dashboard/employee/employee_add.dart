import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/employee_service.dart';

class EmployeeAdd extends StatefulWidget {
  final EmployeesModel? userToEdit;
  const EmployeeAdd({Key? key, this.userToEdit}) : super(key: key);
  @override
  _CustomerAddState createState() => _CustomerAddState();
}

class _CustomerAddState extends State<EmployeeAdd> {
  bool isEdit = false;
  Map<String, dynamic> bodyToUpdate = {};
  //TODO: complete the fields
  // String? picture;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  // TextEditingController countryController = TextEditingController();
  // TextEditingController stateController = TextEditingController();
  // TextEditingController cityController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    if (widget.userToEdit != null) {
      fnameController.text = widget.userToEdit!.fname!;
      lnameController.text = widget.userToEdit!.lname!;
      emailController.text = widget.userToEdit!.email!;
      addressController.text = widget.userToEdit!.address!;
      contactNumberController.text = widget.userToEdit!.contactNumber!;
      isEdit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Admin admin = Provider.of<Authentication>(context, listen: false).data;s

    EmployeeSevice employeeService =
        Provider.of<EmployeeSevice>(context, listen: false);
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
                "Ajouter un Employee",
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
                onChanged: (value) {
                  bodyToUpdate.addAll({"first_name": value});
                },
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
                onChanged: (value) {
                  bodyToUpdate.addAll({"last_name": value});
                },
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
                onChanged: (value) {
                  bodyToUpdate.addAll({"email": value});
                },
              ),
              isEdit
                  ? SizedBox()
                  : TextField(
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      controller: passwordController,
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
                onChanged: (value) {
                  bodyToUpdate.addAll({"contact_number": value});
                },
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
                onChanged: (value) {
                  bodyToUpdate.addAll({"address": value});
                },
              ),
              SizedBox(
                height: MySpacer.small,
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
                bodyToUpdate
                    .addAll({"user_id": widget.userToEdit!.id.toString()});
                print(bodyToUpdate);
                employeeService.updateUser(body: bodyToUpdate).whenComplete(() {
                  setState(() {
                    widget.userToEdit!.fname = fnameController.text;
                    widget.userToEdit!.lname = lnameController.text;
                    widget.userToEdit!.email = emailController.text;
                    widget.userToEdit!.address = addressController.text;
                    widget.userToEdit!.contactNumber =
                        contactNumberController.text;
                  });
                  Navigator.pop(context);
                });
              } else {
                EmployeesModel newEmployee = EmployeesModel(
                  fname: fnameController.text,
                  lname: lnameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  address: addressController.text,
                  contactNumber: contactNumberController.text,
                );

                employeeService
                    .createUser(newEmployee)
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
