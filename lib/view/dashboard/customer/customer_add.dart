import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
      constraints: BoxConstraints(maxWidth: 800, maxHeight: size.height / 1.3),
      padding: EdgeInsets.all(10),
      child: Form(
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
                        customerService.base64Image = pickedFile.files[0].bytes;
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
                                file: customerService.base64Image,
                                netWorkImage: widget.customerToEdit?.picture,
                                defaultImage: 'icons/admin_icon.png'),
                            scale: 1)),
                  ),
                )),
              ),
              SizedBox(
                height: MySpacer.large,
              ),
              TextField(
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
              SizedBox(
                height: MySpacer.small,
              ),
              TextField(
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
              TextField(
                onChanged: (value) {
                  bodyToEdit.addAll({"email": value});
                },
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
                onChanged: (value) {
                  bodyToEdit.addAll({"contact_number": value});
                },
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
                onChanged: (value) {
                  bodyToEdit.addAll({"address": value});
                },
                decoration: InputDecoration(
                  hintText: "Address",
                  border: OutlineInputBorder(),
                ),
                controller: addressController,
              ),
              SizedBox(
                height: MySpacer.small,
              ),
              // TextField(
              //   onChanged: (value) {
              //     bodyToEdit.addAll({"address": value});
              //   },
              //   decoration: InputDecoration(
              //     hintText: "Status",
              //     border: OutlineInputBorder(),
              //   ),
              //   controller: amountController,
              // ),
            ],
          ))),
          MaterialButton(
            height: 60,
            minWidth: double.infinity,
            color: Palette.drawerColor,
            onPressed: () {
              if (isEdit) {
                setState(() {
                  bodyToEdit
                      .addAll({"id": widget.customerToEdit!.id.toString()});
                  customerService
                      .updateCustomer(bodyToEdit: bodyToEdit)
                      .whenComplete(() => Navigator.pop(context));
                });
              } else {
                CustomerModel newCustomer = CustomerModel(
                  fname: fnameController.text,
                  lname: lnameController.text,
                  email: emailController.text,
                  adress: addressController.text,
                  picture: customerService.base64Image != null
                      ? customerService.base64ImageEncoded
                      : "",
                  contactNumber: contactNumberController.text,
                );

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
