import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/profile_service.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String originalPass = "";
  Future getPass() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    originalPass = _prefs.getString('password')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getPass();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scrW = MediaQuery.of(context).size.width;
    final scrH = MediaQuery.of(context).size.height;

    ProfileService profile = Provider.of<ProfileService>(context);

    return Container(
      width: scrW,
      height: scrH,
      constraints: BoxConstraints(maxWidth: 800, maxHeight: scrH / 2.9),
      padding: EdgeInsets.all(10),
      child: Form(
          key: profile.formKeyPassword,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change Password",
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
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the old password';
                      }

                      if (value != originalPass) {
                        return 'Incorrect Password';
                      }
                      return null;
                    },
                    controller: profile.oldPassword,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Old Password",
                        border: OutlineInputBorder(),
                        hintStyle: transHeader),
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the new password';
                      }
                      return null;
                    },
                    controller: profile.newPassword,
                    decoration: InputDecoration(
                      hintText: "New Passwrod",
                      hintStyle: transHeader,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the same password to confirm';
                      }
                      if (value != profile.newPassword.text) {
                        return 'Incorrect Password';
                      }
                      return null;
                    },
                    controller: profile.confirmPassword,
                    decoration: InputDecoration(
                      hintText: "Confirm Passwrod",
                      hintStyle: transHeader,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ))),
              MaterialButton(
                height: 60,
                minWidth: double.infinity,
                color: Palette.drawerColor,
                onPressed: () {
                  if (profile.formKeyPassword.currentState!.validate()) {
                    profile
                        .changePassword(profileData!.id.toString())
                        .whenComplete(() {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text(
                  "Reset Password",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )),
    );
  }
}
