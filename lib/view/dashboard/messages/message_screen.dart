import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/message_service.dart';
import 'package:uitemplate/services/messaging/messaging_data_helper.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view_model/messaging/image_viewer.dart';
import 'package:uitemplate/view_model/messaging/view.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with SettingsHelper {
  // String? base64Image;
  // String fileNameAndSize = "";
  late ImageViewer _viewer = ImageViewer(callback: (value) {
    setState(() {
      Views.b64Image = null;
    });
  });
  List<EmployeesModel> _recepients = [];
  String message = "";
  bool _showList = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<EmployeeSevice>(context, listen: false).fetchUsers();
    super.initState();
  }

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    MessageService messageService = Provider.of<MessageService>(context);
    EmployeeSevice employeeSevice = Provider.of<EmployeeSevice>(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      body: Container(
          width: size.width,
          height: size.height,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: AppBar(
                          centerTitle: false,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          title: Text(
                            "Messagerie",
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            IconButton(
                              icon: Icon(
                                Icons.attach_file_outlined,
                                color: Palette.drawerColor,
                              ),
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                MessagingDataHelper.pickImage((value) {
                                  setState(() {
                                    Views.b64Image = value;
                                  });
                                });
                              },
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            MaterialButton(
                              padding: const EdgeInsets.all(20),
                              onPressed: () =>
                                  setState(() => _showList = !_showList),
                              minWidth: 60,
                              height: 60,
                              color: Theme.of(context).accentColor,
                              child: Center(
                                child: Image.asset(
                                  "assets/icons/icon.png",
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                          automaticallyImplyLeading: false,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: Scrollbar(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            children: [
                              Container(
                                width: double.infinity,
                                child: Text(
                                  "Destinataire(s) :",
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .fontSize! -
                                          2),
                                ),
                              ),
                              if (_recepients.isNotEmpty) ...{
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  child: Text(
                                    "Cliquez sur l'élément à supprimer de la liste",
                                    style: TextStyle(
                                        color: Palette.drawerColor
                                            .withOpacity(0.5),
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .fontSize),
                                  ),
                                ),
                              },
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                child: Wrap(
                                    children: List.generate(
                                        _recepients.length,
                                        (index) => Container(
                                              margin: const EdgeInsets.only(
                                                  right: 15, bottom: 10),
                                              child: MaterialButton(
                                                color: Colors.grey.shade300,
                                                onPressed: () {
                                                  setState(() {
                                                    _recepients.removeAt(index);
                                                  });
                                                },
                                                child: Text(
                                                  "${_recepients[index].fname} ${_recepients[index].lname}",
                                                  style: TextStyle(
                                                      fontSize:
                                                          Theme.of(context)
                                                                  .textTheme
                                                                  .headline6!
                                                                  .fontSize! -
                                                              4,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ))),
                              ),
                              if (Views.b64Image != null) ...{_viewer},
                              Views.textField((size.height / 50).ceil(),
                                  callback: (text) {
                                setState(() {
                                  message = text;
                                });
                              })
                            ],
                          ),
                        ),
                      )),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: MaterialButton(
                          onPressed:
                              (message != "" && _recepients.isNotEmpty) ||
                                      (Views.b64Image != null &&
                                          _recepients.isNotEmpty)
                                  ? () {
                                      var stringRecepients = "";
                                      List empIds = [];
                                      for (EmployeesModel emp in _recepients) {
                                        empIds.add(emp.id);
                                      }

                                      stringRecepients = empIds
                                          .toString()
                                          .replaceAll("[", "")
                                          .replaceAll("]", "");

                                      messageService.sendMessage(
                                          ids: stringRecepients,
                                          message: message,
                                          base64File: Views.b64Image);
                                      print(stringRecepients);
                                    }
                                  : null,
                          height: 60,
                          disabledColor: Colors.grey,
                          color: Palette.drawerColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Envoyer",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .fontSize! -
                                        4,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(
                  milliseconds: 500,
                ),
                width: _showList ? 300 : 0,
                height: size.height,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "Employees",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headline6!
                                .fontSize),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      child: employeeSevice.users == null
                          ? Views.shimmerLoader()
                          : Views.employeesList(employeeSevice,
                              callback: (employeeData) {
                              if (!MessagingDataHelper.contains(
                                  _recepients, employeeData.id!)) {
                                print(employeeData);
                                setState(() {
                                  _recepients.add(employeeData);
                                });
                              }
                            }),
                    ))
                  ],
                ),
              )
            ],
          )),
    );
    // return Container(
    //   padding: EdgeInsets.all(20),
    //   color: Colors.white,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         "ENVOYER UNE NOTIFICATION PUSH",
    //         style: Theme.of(context).textTheme.headline6,
    //       ),
    //       SizedBox(
    //         height: MySpacer.medium,
    //       ),
    //       Text(
    //         "Employees",
    //         style: boldText,
    //       ),
    //       employeeSevice.users == null
    //           ? Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : employeeSevice.users.length == 0
    //               ? Text("No user to Assign")
    //               : Container(
    //                   height: 60,
    //                   width: double.infinity,
    //                   child: ListView.builder(
    //                       scrollDirection: Axis.horizontal,
    //                       itemCount: employeeSevice.users.length,
    //                       itemBuilder: (context, index) {
    //                         return messageService.userToMessage
    //                                 .contains(employeeSevice.users[index])
    //                             ? GestureDetector(
    //                                 onTap: () {
    //                                   messageService.removeUser(
    //                                       employeeSevice.users[index]);
    //                                 },
    //                                 child: Container(
    //                                     margin: EdgeInsets.all(5),
    //                                     height: 60,
    //                                     width: 150,
    //                                     child: Card(
    //                                       color: Palette.drawerColor,
    //                                       margin: EdgeInsets.all(0),
    //                                       child: ListTile(
    //                                         title: Text(
    //                                           employeeSevice.users[index].fname,
    //                                           style: TextStyle(
    //                                               color: Colors.white),
    //                                         ),
    //                                       ),
    //                                     )),
    //                               )
    //                             : GestureDetector(
    //                                 onTap: () {
    //                                   messageService.addUserToMessage(
    //                                       employeeSevice.users[index]);
    //                                 },
    //                                 child: Container(
    //                                   margin: EdgeInsets.all(5),
    //                                   height: 60,
    //                                   width: 150,
    //                                   child: Card(
    //                                     child: ListTile(
    //                                       title: Text(employeeSevice
    //                                           .users[index].fname),
    //                                     ),
    //                                   ),
    //                                 ));
    //                       }),
    //                 ),
    //       Container(
    //         height: 5 * 24.0,
    //         child: TextField(
    //           onChanged: (_) {
    //             messageService.messageUpdate();
    //           },
    //           controller: messageService.messageController,
    //           maxLines: 5,
    //           decoration: InputDecoration(
    //             border:
    //                 OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    //             hintText: "Message",
    //           ),
    //         ),
    //       ),
    //       Container(
    //         width: 500,
    //         padding: EdgeInsets.symmetric(
    //           vertical: 10,
    //         ),
    //         child: Card(
    //             child: fileNameAndSize.isEmpty
    //                 ? null
    //                 : Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Flexible(
    //                         child: Text(
    //                           fileNameAndSize,
    //                           overflow: TextOverflow.ellipsis,
    //                         ),
    //                       ),
    //                       IconButton(
    //                           onPressed: () {
    //                             setState(() {
    //                               base64Image = null;
    //                               fileNameAndSize = "";
    //                             });
    //                           },
    //                           icon: Icon(Icons.close))
    //                     ],
    //                   )),
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 5),
    //             child: MaterialButton(
    //                 height: 60,
    //                 minWidth: 60,
    //                 onPressed: () async {
    //                   await FilePicker.platform.pickFiles(
    //                       allowMultiple: false,
    //                       allowedExtensions: [
    //                         'jpg',
    //                         'jpeg',
    //                         'png'
    //                       ]).then((pickedFile) {
    //                     if (pickedFile != null) {
    //                       setState(() {
    //                         base64Image = pickedFile.files[0].bytes;
    //                         fileNameAndSize = pickedFile.files[0].name! +
    //                             pickedFile.files[0].size.toString();
    //                         print(fileNameAndSize);
    //                       });
    //                     }
    //                   });
    //                 },
    //                 child: Icon(Icons.attach_file)),
    //           ),
    //           Container(
    //             height: 50,
    //             width: MediaQuery.of(context).size.width / 5,
    //             child: BasicButton(
    //               onPressed: messageService.messageController.text.isEmpty ||
    //                       messageService.userToMessage.length == 0
    //                   ? null
    //                   : () {
    //                       List ids = messageService.userToMessage
    //                           .map((element) => element.id)
    //                           .toList();
    //                       String strIds = ids.join(',');
    //                       print(strIds);
    //                       print(authToken);
    //                       messageService.sendMessage(
    //                           ids: strIds,
    //                           message: messageService.messageController.text,
    //                           base64File: base64Image != null
    //                               ? base64.encode(base64Image!.toList())
    //                               : null);
    //                     },
    //               buttonText: "Envoyer",
    //               icon: Icons.send,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
