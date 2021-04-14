import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/services/autentication.dart';

class AdminProfile extends StatefulWidget {
  final bool? showProfile;

  const AdminProfile({Key? key, @required this.showProfile}) : super(key: key);
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Authentication>(context, listen: false);
    auth.getLocalProfile();
    Admin admin = auth.data;
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
            Text(admin.firstName!),
            Text(admin.email!),
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
