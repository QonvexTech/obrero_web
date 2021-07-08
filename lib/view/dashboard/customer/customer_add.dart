import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/settings/helper.dart';

class CustomerAdd extends StatefulWidget {
  final CustomerModel? customerToEdit;

  const CustomerAdd({Key? key, this.customerToEdit}) : super(key: key);
  @override
  _CustomerAddState createState() => _CustomerAddState();
}

class _CustomerAddState extends State<CustomerAdd> with SettingsHelper {
  bool isEdit = false;
  Map bodyToEdit = {};
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  Map<dynamic, dynamic>? countryValue = countries[66];
  final _formKey = GlobalKey<FormState>();

  final _prenom = FocusNode();
  final _nom = FocusNode();
  final _email = FocusNode();
  final _tel = FocusNode();
  final _address = FocusNode();

  @override
  void initState() {
    if (widget.customerToEdit != null) {
      fnameController.text = widget.customerToEdit!.fname!;
      lnameController.text = widget.customerToEdit!.lname!;
      emailController.text = widget.customerToEdit!.email!;
      addressController.text = widget.customerToEdit!.adress!;
      contactNumberController.text = widget.customerToEdit!.contactNumber!;
      // amountController.text = widget.customerToEdit!.status!.amount!.toString();
      isEdit = true;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    CustomerService customerService = Provider.of<CustomerService>(context);

    return Container(
      width: size.width,
      height: size.height,
      constraints:
          BoxConstraints(maxWidth: 800, maxHeight: (size.height * 0.6) + 40),
      padding: EdgeInsets.all(10),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ajouter un Client",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MySpacer.small,
              ),
              Expanded(
                  child: Scrollbar(
                      child: ListView(
                children: [
                  Container(
                    child: Center(
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
                                      file: customerService.base64Image,
                                      netWorkImage:
                                          widget.customerToEdit?.picture,
                                      defaultImage: 'icons/admin_icon.png'),
                                  scale: 1)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                              color: Palette.drawerColor,
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
                                    customerService.base64Image =
                                        pickedFile.files[0].bytes;
                                  }
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10000)),
                              minWidth: 50,
                              height: 50,
                              child:
                                  Icon(Icons.camera_alt, color: Colors.white)),
                        ),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  RawKeyboardListener(
                    focusNode: _prenom,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Prénom Required!';
                        }
                      },
                      onFieldSubmitted: (x) {
                        _nom.requestFocus();
                      },
                      onChanged: (value) {
                        bodyToEdit.addAll({"first_name": value});
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: "Prénom",
                          border: OutlineInputBorder(),
                          hintStyle: transHeader),
                      controller: fnameController,
                    ),
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  TextFormField(
                    focusNode: _nom,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nom de famillie Required!';
                      }
                    },
                    onFieldSubmitted: (x) {
                      _email.requestFocus();
                    },
                    onChanged: (value) {
                      bodyToEdit.addAll({"last_name": value});
                    },
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
                  TextFormField(
                    focusNode: _email,
                    onFieldSubmitted: (x) {
                      _tel.requestFocus();
                    },
                    onChanged: (value) {
                      bodyToEdit.addAll({"email": value});
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email Required!';
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Invalid Email!';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: transHeader,
                      border: OutlineInputBorder(),
                    ),
                    controller: emailController,
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  TextFormField(
                    focusNode: _tel,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Téléphone Required!';
                      }
                    },
                    onFieldSubmitted: (x) {
                      _address.requestFocus();
                    },
                    onChanged: (value) {
                      bodyToEdit.addAll({"contact_number": value});
                    },
                    decoration: InputDecoration(
                      hintStyle: transHeader,
                      hintText: "Téléphone",
                      border: OutlineInputBorder(),
                    ),
                    controller: contactNumberController,
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
                                hint: Text("Country"),
                                value: countryValue,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Palette.drawerColor),
                                onChanged: (Map<dynamic, dynamic>? newValue) {
                                  setState(() {
                                    countryValue = newValue!;
                                  });
                                },
                                items: countries.map<
                                    DropdownMenuItem<
                                        Map<dynamic, dynamic>>>((value) {
                                  return DropdownMenuItem<
                                      Map<dynamic, dynamic>>(
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
                              child: TextFormField(
                                focusNode: _address,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Address Required!';
                                  }
                                },
                                onChanged: (value) {
                                  bodyToEdit.addAll({"address": value});
                                },
                                decoration: InputDecoration(
                                  hintStyle: transHeader,
                                  hintText: "Address",
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
                            underline: null,
                            hint: Text("Country"),
                            value: countryValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Palette.drawerColor),
                            onChanged: (Map<dynamic, dynamic>? newValue) {
                              setState(() {
                                countryValue = newValue!;
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
                              bodyToEdit.addAll({"address": value});
                            },
                            decoration: InputDecoration(
                              hintStyle: transHeader,
                              hintText: "Address",
                              border: OutlineInputBorder(),
                            ),
                            controller: addressController,
                          ),
                        )
                      : SizedBox(),
                ],
              ))),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: MaterialButton(
                          height: 60,
                          color: Colors.grey[200],
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
                            setState(() {
                              bodyToEdit.addAll(
                                  {"id": widget.customerToEdit!.id.toString()});
                              bodyToEdit.addAll({
                                "picture": customerService.base64Image != null
                                    ? customerService.base64ImageEncoded
                                    : "",
                              });
                              print("BODY TO EDIT $bodyToEdit");
                              customerService
                                  .updateCustomer(bodyToEdit: bodyToEdit)
                                  .whenComplete(() {
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
                            });
                          } else {
                            if (_formKey.currentState!.validate()) {
                              CustomerModel newCustomer = CustomerModel(
                                fname: fnameController.text,
                                lname: lnameController.text,
                                email: emailController.text,
                                adress: addressController.text +
                                    ", ${countryValue!["name"]}",
                                picture: customerService.base64Image != null
                                    ? customerService.base64ImageEncoded
                                    : "",
                                contactNumber: contactNumberController.text,
                              );

                              customerService
                                  .createCustomer(newCustomer: newCustomer)
                                  .whenComplete(() {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    webBgColor:
                                        "linear-gradient(to right, #5585E5, #5585E5)",
                                    msg: "Created Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                    fontSize: 16.0);
                              });
                            }
                          }
                        },
                        child: Text(
                          isEdit ? "Save Edit" : "Créer",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
