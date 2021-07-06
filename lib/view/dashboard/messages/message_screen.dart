import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/message_service.dart';
import 'package:uitemplate/view/dashboard/messages/destination_list.dart';
import 'package:uitemplate/widgets/adding_button.dart';
import 'package:uitemplate/widgets/basicButton.dart';

import '../../../config/global.dart';
import '../../../services/autentication.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MessageService messageService = Provider.of<MessageService>(context);
    return Container(
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ENVOYER UNE NOTIFICATION PUSH",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text("Users"),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 60,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (EmployeesModel user
                                  in messageService.userToMessage)
                                Chip(label: Text(user.fname!))
                            ],
                          ),
                        )),
                        SizedBox(
                          width: MySpacer.small,
                        ),
                        AddingButton(
                            addingPage: DestinationList(),
                            buttonText: "Destinataires")
                      ],
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Message",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MySpacer.small,
                    ),
                    BasicButton(
                        onPressed: messageService
                                    .messageController.text.isEmpty ||
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
                                    message:
                                        messageService.messageController.text);
                              },
                        buttonText: "Envoyer")
                  ],
                ),
              )),
          Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
