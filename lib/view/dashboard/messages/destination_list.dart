import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/message_service.dart';

class DestinationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EmployeeSevice employeeSevice = Provider.of<EmployeeSevice>(context);
    MessageService messageService = Provider.of<MessageService>(context);
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: employeeSevice.users!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (!messageService.userToMessage
                    .contains(employeeSevice.users![index])) {
                  messageService.addUserToMessage(employeeSevice.users![index]);
                } else {
                  print("Already Added");
                }
              },
              child: Card(
                child: ListTile(
                  // leading: Checkbox(value: value, onChanged: onChanged),
                  title: Text(employeeSevice.users![index].fname!),
                ),
              ),
            );
          }),
    );
  }
}
