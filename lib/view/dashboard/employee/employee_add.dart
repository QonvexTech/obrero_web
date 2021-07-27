import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Map<dynamic, dynamic>? countryValue = countries[66];
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
      List lastWordCountry = widget.userToEdit!.address!.split(",");
      String country = lastWordCountry[lastWordCountry.length - 1];

      try {
        countryValue = countries.firstWhere((element) =>
            element.entries.first.value == country.replaceFirst(" ", ""));
      } catch (e) {
        countryValue = countries[66];
      }
      isEdit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EmployeeSevice employeeService = Provider.of<EmployeeSevice>(context);

    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      constraints:
          BoxConstraints(maxWidth: 800, maxHeight: (size.height * 0.7) + 15),
      padding: EdgeInsets.all(10),
      child: Form(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ajouter un employé",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MySpacer.large,
          ),
          Expanded(
              child: Scrollbar(
                  child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
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
                  ],
                ),
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
                  hintText: "Nom de famille",
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
              isEdit
                  ? SizedBox()
                  : TextField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: transHeader,
                        border: OutlineInputBorder(),
                      ),
                      controller: emailController,
                      onChanged: (value) {
                        bodyToUpdate.addAll({"email": value});
                      },
                    ),
              isEdit
                  ? SizedBox()
                  : SizedBox(
                      height: MySpacer.small,
                    ),
              isEdit
                  ? SizedBox()
                  : TextField(
                      decoration: InputDecoration(
                        hintText: "Mot de passe",
                        hintStyle: transHeader,
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
                  hintStyle: transHeader,
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
              MediaQuery.of(context).size.width > 800
                  ? Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButton<Map<dynamic, dynamic>>(
                            underline: null,
                            isExpanded: true,
                            hint: Text("Pays"),
                            value: countryValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Palette.drawerColor),
                            onChanged: (Map<dynamic, dynamic>? newValue) {
                              setState(() {
                                countryValue = newValue!;
                                print("country down");
                                if (isEdit) {
                                  var newAddress =
                                      widget.userToEdit!.address!.split(",");

                                  addressController.text = newAddress[0] +
                                      ", ${countryValue!["name"]}";

                                  bodyToUpdate.addAll(
                                      {"address": addressController.text});
                                }
                              });
                            },
                            items: countries
                                .map<DropdownMenuItem<Map<dynamic, dynamic>>>(
                                    (value) {
                              return DropdownMenuItem<Map<dynamic, dynamic>>(
                                value: value,
                                child: Text(
                                  value["name"],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: MySpacer.small,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            onChanged: (value) {
                              bodyToUpdate.addAll({"address": value});
                            },
                            decoration: InputDecoration(
                              hintStyle: transHeader,
                              hintText: "Adresse",
                              border: OutlineInputBorder(),
                            ),
                            controller: addressController,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              MediaQuery.of(context).size.width < 800
                  ? Expanded(
                      child: DropdownButton<Map<dynamic, dynamic>>(
                        isExpanded: true,
                        underline: null,
                        hint: Text("Pays"),
                        value: countryValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Palette.drawerColor),
                        onChanged: (Map<dynamic, dynamic>? newValue) {
                          setState(() {
                            countryValue = newValue!;
                            if (isEdit) {
                              var newAddress =
                                  widget.userToEdit!.address!.split(",");

                              addressController.text =
                                  newAddress[0] + ", ${countryValue!["name"]}";

                              bodyToUpdate
                                  .addAll({"address": addressController.text});
                            }
                          });
                        },
                        items: countries
                            .map<DropdownMenuItem<Map<dynamic, dynamic>>>(
                                (value) {
                          return DropdownMenuItem<Map<dynamic, dynamic>>(
                            value: value,
                            child: Text(
                              value["name"],
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                  width: MediaQuery.of(context).size.width < 800
                      ? 0
                      : MySpacer.small),
              MediaQuery.of(context).size.width < 800
                  ? Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: (value) {
                          bodyToUpdate.addAll({"address": value});
                        },
                        decoration: InputDecoration(
                          hintStyle: transHeader,
                          hintText: "Adresse",
                          border: OutlineInputBorder(),
                        ),
                        controller: addressController,
                      ),
                    )
                  : SizedBox(),
            ],
          ))),
          const SizedBox(
            height: MySpacer.small,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: MaterialButton(
                      color: Colors.grey[200],
                      height: 60,
                      minWidth: double.infinity,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Annuler",
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MySpacer.medium),
                Expanded(
                    flex: 2,
                    child: MaterialButton(
                      height: 60,
                      minWidth: double.infinity,
                      color: Palette.drawerColor,
                      onPressed: () {
                        if (isEdit) {
                          bodyToUpdate.addAll(
                              {"user_id": widget.userToEdit!.id.toString()});

                          employeeService
                              .updateUser(body: bodyToUpdate)
                              .whenComplete(() {
                            setState(() {
                              widget.userToEdit!.fname = fnameController.text;
                              widget.userToEdit!.lname = lnameController.text;
                              widget.userToEdit!.email = emailController.text;
                              widget.userToEdit!.address =
                                  addressController.text;
                              widget.userToEdit!.contactNumber =
                                  contactNumberController.text;
                            });

                            Fluttertoast.showToast(
                                webBgColor:
                                    "linear-gradient(to right, #5585E5, #5585E5)",
                                msg: "Upadated Successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                fontSize: 16.0);
                            Navigator.pop(context);
                          });
                        } else {
                          EmployeesModel newEmployee = EmployeesModel(
                            fname: fnameController.text,
                            lname: lnameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            address: addressController.text +
                                ", ${countryValue!["name"]}",
                            contactNumber: contactNumberController.text,
                          );

                          employeeService
                              .createUser(newEmployee)
                              .whenComplete(() {
                            Fluttertoast.showToast(
                                webBgColor:
                                    "linear-gradient(to right, #5585E5, #5585E5)",
                                msg: "Created Successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                fontSize: 16.0);
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text(
                        isEdit ? "Sauvegarder" : "Créer",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ],
            ),
          )
        ],
      )),
    );
  }
}
