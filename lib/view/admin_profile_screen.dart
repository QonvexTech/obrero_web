import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/profile_service.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({
    Key? key,
  }) : super(key: key);
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    ProfileService adminService = Provider.of<ProfileService>(context);
    return Card(
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
            ),
            SizedBox(
              height: MySpacer.medium,
            ),
            Text(adminService.admin!.firstName!),
            Text(adminService.admin!.email!),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  child: Text("logout"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
