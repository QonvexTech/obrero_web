import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/message_service.dart';
import 'package:uitemplate/services/messaging/messaging_data_helper.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view_model/messaging/image_viewer.dart';
import 'package:uitemplate/view_model/messaging/view.dart';
import 'package:uitemplate/widgets/message_history.dart';

class MessageScreen extends StatefulWidget {
  final List<EmployeesModel> recepients;

  const MessageScreen({Key? key, required this.recepients}) : super(key: key);
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with SettingsHelper {
  bool messageSending = false;

  late ImageViewer _viewer = ImageViewer(callback: (value) {
    setState(() {
      Views.b64Image = null;
    });
  });

  String message = "";
  bool _showList = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<EmployeeSevice>(context, listen: false).initLoad();
    super.initState();
  }

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    MessageService messageService = Provider.of<MessageService>(context);
    EmployeeSevice employeeSevice = Provider.of<EmployeeSevice>(context);

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Palette.contentBackground,
      key: _key,
      body: messageSending
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Envoi en cours...")
                ],
              ),
            )
          : Container(
              width: size.width,
              height: size.height,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 20),
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
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: MaterialButton(
                                    padding: const EdgeInsets.all(15),
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
                                  ),
                                ),
                                SizedBox(width: 25)
                              ],
                              automaticallyImplyLeading: false,
                            ),
                          ),
                          Expanded(
                              child: Container(
                            child: Scrollbar(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
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
                                  if (widget.recepients.isNotEmpty) ...{
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
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
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    width: double.infinity,
                                    child: Wrap(
                                        children: List.generate(
                                            widget.recepients.length,
                                            (index) => Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 15, bottom: 10),
                                                  child: MaterialButton(
                                                    color: Colors.grey.shade300,
                                                    onPressed: () {
                                                      setState(() {
                                                        widget.recepients
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    child: Text(
                                                      "${widget.recepients[index].fname} ${widget.recepients[index].lname}",
                                                      style: TextStyle(
                                                          fontSize: Theme.of(
                                                                      context)
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
                          MaterialButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                      backgroundColor:
                                          Palette.contentBackground,
                                      content: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: MessageHistory())));
                            },
                            child: Text("History"),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: MaterialButton(
                              onPressed: (message != "" &&
                                          widget.recepients.isNotEmpty) ||
                                      (Views.b64Image != null &&
                                          widget.recepients.isNotEmpty)
                                  ? () {
                                      setState(() {
                                        messageSending = true;
                                      });
                                      var stringRecepients = "";
                                      List empIds = [];
                                      for (EmployeesModel emp
                                          in widget.recepients) {
                                        empIds.add(emp.id);
                                      }

                                      stringRecepients = empIds
                                          .toString()
                                          .replaceAll("[", "")
                                          .replaceAll("]", "");

                                      messageService
                                          .sendMessage(
                                              ids: stringRecepients,
                                              message: message,
                                              base64File: Views.b64Image)
                                          .then((value) {
                                        if (value) {
                                          Fluttertoast.showToast(
                                              webBgColor:
                                                  "linear-gradient(to right, #5585E5, #5585E5)",
                                              msg: "Message envoyé avec succès",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 2,
                                              fontSize: 16.0);
                                        }
                                        setState(() {
                                          messageSending = false;
                                          Views.message.clear();
                                        });
                                      });
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

                        employeeSevice.userload == null
                            ? Center(child: CircularProgressIndicator())
                            : employeeSevice.userload!.length == 0
                                ? Text("No employee to assign")
                                : Container(
                                    height: 800,
                                    child: LazyLoadScrollView(
                                      isLoading: true,
                                      onEndOfPage: () {
                                        setState(() {
                                          employeeSevice.loadMore();
                                        });
                                      },
                                      child: ListView.builder(
                                          itemCount:
                                              employeeSevice.userload!.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  if (!MessagingDataHelper
                                                      .contains(
                                                          widget.recepients,
                                                          employeeSevice
                                                              .userload[index]
                                                              .id!)) {
                                                    setState(() {
                                                      widget.recepients.add(
                                                          employeeSevice
                                                              .userload[index]);
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(5),
                                                  height: 60,
                                                  width: 200,
                                                  child: Card(
                                                    child: Center(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            maxRadius: 15,
                                                            backgroundImage: fetchImage(
                                                                netWorkImage:
                                                                    employeeSevice
                                                                        .userload![
                                                                            index]
                                                                        .picture),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                MySpacer.small,
                                                          ),
                                                          Text(
                                                            "${employeeSevice.userload![index].fname!} ${employeeSevice.userload![index].lname!}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                  ),
                                                ));
                                          }),
                                    ),
                                  ),

                        // Expanded(
                        //     child: Container(
                        //   child: employeeSevice.users == null
                        //       ? Views.shimmerLoader()
                        //       : Views.employeesList(employeeSevice,
                        //           callback: (employeeData) {
                        //           if (!MessagingDataHelper.contains(
                        //               widget.recepients, employeeData.id!)) {
                        //             print(employeeData);
                        //             setState(() {
                        //               widget.recepients.add(employeeData);
                        //               // messageSending = false;
                        //             });
                        //           }
                        //         }),
                        // ))
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

  static ImageProvider _imageProvider({String? image}) {
    if (image == null) {
      return AssetImage("assets/icons/admin_icon.png");
    } else {
      return NetworkImage("https://obrero.checkmy.dev$image");
    }
  }
}
