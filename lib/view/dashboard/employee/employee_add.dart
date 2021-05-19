import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/settings/helper.dart';

class EmployeeAdd extends StatefulWidget {
  final EmployeesModel? userToEdit;
  const EmployeeAdd({Key? key, this.userToEdit}) : super(key: key);
  @override
  _CustomerAddState createState() => _CustomerAddState();
}

class _CustomerAddState extends State<EmployeeAdd> with SettingsHelper {
  bool isEdit = false;
  Map<String, dynamic> bodyToUpdate = {};
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
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
    EmployeeSevice employeeService =
        Provider.of<EmployeeSevice>(context, listen: false);
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
              Container(
                child: Center(
                    child: MaterialButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () async {
                    await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        allowedExtensions: [
                          'jpg',
                          'jpeg',
                          'png'
                        ]).then((pickedFile) {
                      if (pickedFile != null) {
                        employeeService.base64Image = pickedFile.files[0].bytes;
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10000)),
                  minWidth: MediaQuery.of(context).size.height * .15,
                  height: MediaQuery.of(context).size.height * .15,
                  child: Container(
                    width: MediaQuery.of(context).size.height * .15,
                    height: MediaQuery.of(context).size.height * .15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10000),
                        color: Colors.grey.shade100,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: Offset(3, 3),
                            blurRadius: 2,
                          )
                        ],
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            alignment: AlignmentDirectional.center,
                            image: tempImageProvider(
                                file: employeeService.base64Image,
                                netWorkImage: widget.userToEdit?.picture,
                                defaultImage: 'icons/admin_icon.png'),
                            scale: 1)),
                  ),
                )),
              ),
              SizedBox(
                height: MySpacer.large,
              ),
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
              SizedBox(
                height: MySpacer.small,
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
                  picture: employeeService.base64Image != null
                      ? employeeService.base64ImageEncoded
                      : "",
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
