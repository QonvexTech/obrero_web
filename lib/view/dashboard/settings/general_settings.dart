import 'dart:ui';
import 'package:adaptive_container/adaptive_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/profile_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/tracker.dart';
import '../../../config/global.dart';
import '../../../config/pallete.dart';
import '../../../services/employee_service.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> with SettingsHelper {
  EmployeeSevice _service = new EmployeeSevice();
  TextEditingController email = new TextEditingController()
    ..text = profileData!.email!;
  TextEditingController first_name = new TextEditingController()
    ..text = profileData!.firstName!;
  TextEditingController last_name = new TextEditingController()
    ..text = profileData!.lastName!;
  TextEditingController password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double _scrw = MediaQuery.of(context).size.width;
    final double _scrh = MediaQuery.of(context).size.height;
    ProfileService profileService = Provider.of<ProfileService>(context);
    return Container(
      padding: EdgeInsets.all(20),
      color: Palette.contentBackground,
      child: Stack(
        children: [
          Center(
            child: Container(
                width: _scrw * 0.4,
                height: _scrh,
                color: Palette.contentBackground,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: _scrh * .15,
                            height: _scrh * .15,
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
                                    fit: profileData?.picture == null &&
                                            profileService.base64Image == null
                                        ? BoxFit.scaleDown
                                        : BoxFit.cover,
                                    alignment: profileData?.picture == null &&
                                            profileService.base64Image == null
                                        ? AlignmentDirectional.bottomCenter
                                        : AlignmentDirectional.center,
                                    image: tempImageProvider(
                                        file: profileService.base64Image,
                                        netWorkImage: profileData?.picture,
                                        defaultImage: 'images/emptyImage.jpg'),
                                    scale:
                                        profileData?.picture == null ? 5 : 1)),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: MaterialButton(
                                color: Palette.drawerColor,
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
                                      profileService.base64Image =
                                          pickedFile.files[0].bytes;
                                    }
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10000)),
                                minWidth: 50,
                                height: 50,
                                child: Icon(Icons.camera_alt,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySpacer.medium,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: AdaptiveContainer(
                              children: [
                                AdaptiveItem(
                                    content: customTextField(
                                        controller: first_name,
                                        label: "Prénom")),
                                AdaptiveItem(
                                    content: customTextField(
                                        controller: last_name, label: "Nom")),
                                // AdaptiveItem(
                                //     content: customTextField(controller: email, label: "Email")
                                // ),
                              ],
                            ),
                          ),
                          customTextField(controller: email, label: "Email"),
                          SizedBox(
                            height: MySpacer.medium,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () async {
                                Map<String, dynamic> body = {
                                  "user_id": profileData!.id.toString()
                                };
                                if (email.text != profileData!.email) {
                                  body.addAll({"email": email.text});
                                }
                                if (first_name.text != profileData!.firstName) {
                                  body.addAll({"first_name": first_name.text});
                                }
                                if (last_name.text != profileData!.lastName) {
                                  body.addAll({"last_name": last_name.text});
                                }
                                if (profileService.base64Image != null) {
                                  body.addAll({
                                    "picture":
                                        "data:image/jpg;base64,${profileService.base64ImageEncoded}"
                                  });
                                }
                                if (body.length > 1) {
                                  setState(() {
                                    profileService.isLoading = true;
                                  });
                                  await _service
                                      .updateUser(body: body, isAdmin: true)
                                      .then((success) {
                                    profileService.isLoading = false;
                                    if (success) {
                                      Fluttertoast.showToast(
                                          webBgColor:
                                              "linear-gradient(to right, #5585E5, #5585E5)",
                                          msg: "Mise à jour réussie",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 2,
                                          fontSize: 16.0);
                                    }
                                  });
                                } else {
                                  print("CANT UPDATE");
                                }
                              },
                              child: Center(
                                child: Text(
                                  "Mettre à jour",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              color: Palette.drawerColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: TrackerPage(),
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                )),
          ),
          profileService.isLoading
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    width: double.infinity,
                    height: _scrh,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Palette.drawerColor),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
