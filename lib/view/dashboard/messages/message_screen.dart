import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/message_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/widgets/basicButton.dart';
import '../../../config/global.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with SettingsHelper {
  Uint8List? base64Image;
  String fileNameAndSize = "";
  @override
  void initState() {
    Provider.of<EmployeeSevice>(context, listen: false).fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MessageService messageService = Provider.of<MessageService>(context);
    EmployeeSevice employeeSevice = Provider.of<EmployeeSevice>(context);
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ENVOYER UNE NOTIFICATION PUSH",
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: MySpacer.medium,
          ),
          Text(
            "Employees",
            style: boldText,
          ),
          employeeSevice.users == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : employeeSevice.users.length == 0
                  ? Text("No user to Assign")
                  : Container(
                      height: 60,
                      width: double.infinity,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: employeeSevice.users.length,
                          itemBuilder: (context, index) {
                            return messageService.userToMessage
                                    .contains(employeeSevice.users[index])
                                ? GestureDetector(
                                    onTap: () {
                                      messageService.removeUser(
                                          employeeSevice.users[index]);
                                    },
                                    child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 60,
                                        width: 150,
                                        child: Card(
                                          color: Palette.drawerColor,
                                          margin: EdgeInsets.all(0),
                                          child: ListTile(
                                            title: Text(
                                              employeeSevice.users[index].fname,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      messageService.addUserToMessage(
                                          employeeSevice.users[index]);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      height: 60,
                                      width: 150,
                                      child: Card(
                                        child: ListTile(
                                          title: Text(employeeSevice
                                              .users[index].fname),
                                        ),
                                      ),
                                    ));
                          }),
                    ),
          Container(
            height: 5 * 24.0,
            child: TextField(
              onChanged: (_) {
                messageService.messageUpdate();
              },
              controller: messageService.messageController,
              maxLines: 5,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                hintText: "Message",
              ),
            ),
          ),
          Container(
            width: 500,
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Card(
                child: fileNameAndSize.isEmpty
                    ? null
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              fileNameAndSize,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  base64Image = null;
                                  fileNameAndSize = "";
                                });
                              },
                              icon: Icon(Icons.close))
                        ],
                      )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: MaterialButton(
                    height: 60,
                    minWidth: 60,
                    onPressed: () async {
                      await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          allowedExtensions: [
                            'jpg',
                            'jpeg',
                            'png'
                          ]).then((pickedFile) {
                        if (pickedFile != null) {
                          setState(() {
                            base64Image = pickedFile.files[0].bytes;
                            fileNameAndSize = pickedFile.files[0].name! +
                                pickedFile.files[0].size.toString();
                            print(fileNameAndSize);
                          });
                        }
                      });
                    },
                    child: Icon(Icons.attach_file)),
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 5,
                child: BasicButton(
                  onPressed: messageService.messageController.text.isEmpty ||
                          messageService.userToMessage.length == 0
                      ? null
                      : () {
                          List ids = messageService.userToMessage
                              .map((element) => element.id)
                              .toList();
                          String strIds = ids.join(',');
                          print(strIds);
                          print(authToken);
                          messageService.sendMessage(
                              ids: strIds,
                              message: messageService.messageController.text,
                              base64File: base64Image != null
                                  ? base64.encode(base64Image!.toList())
                                  : null);
                        },
                  buttonText: "Envoyer",
                  icon: Icons.send,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
