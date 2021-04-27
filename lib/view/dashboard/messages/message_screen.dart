import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/message_service.dart';
import 'package:uitemplate/widgets/basicButton.dart';
import '../../../config/global.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MessageService messageService = Provider.of<MessageService>(context);
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
          Consumer<EmployeeSevice>(
            builder: (_, data, child) {
              return Container(
                height: 60,
                width: double.infinity,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.users.length,
                    itemBuilder: (context, index) {
                      return messageService.userToMessage
                              .contains(data.users[index])
                          ? GestureDetector(
                              onTap: () {
                                messageService.removeUser(data.users[index]);
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
                                        data.users[index].fname,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )),
                            )
                          : GestureDetector(
                              onTap: () {
                                messageService
                                    .addUserToMessage(data.users[index]);
                              },
                              child: Container(
                                margin: EdgeInsets.all(5),
                                height: 60,
                                width: 150,
                                child: Card(
                                  child: ListTile(
                                    title: Text(data.users[index].fname),
                                  ),
                                ),
                              ));
                    }),
              );
            },
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
          SizedBox(
            height: MySpacer.small,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                              message: messageService.messageController.text);
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
