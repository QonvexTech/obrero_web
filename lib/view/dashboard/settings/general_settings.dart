import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:adaptive_container/adaptive_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/profile_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import '../../../config/global.dart';
import '../../../config/pallete.dart';
import '../../../services/employee_service.dart';

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> with SettingsHelper {
  EmployeeSevice _service = new EmployeeSevice();

  @override
  Widget build(BuildContext context) {
    final double _scrw = MediaQuery.of(context).size.width;
    final double _scrh = MediaQuery.of(context).size.height;
    ProfileService profileService = Provider.of<ProfileService>(context);
    return Stack(
      children: [
        Container(
            width: _scrw,
            height: _scrh,
            color: Palette.contentBackground,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: _scrh * .3,
                  child: Center(
                      child: MaterialButton(
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
                    minWidth: _scrh * .26,
                    height: _scrh * .26,
                    child: Container(
                      width: _scrh * .26,
                      height: _scrh * .26,
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
                                  netWorkImage: profileData?.picture),
                              scale: profileData?.picture == null ? 5 : 1)),
                    ),
                  )),
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
                                  controller: first_name, label: "Prénom")),
                          AdaptiveItem(
                              content: customTextField(
                                  controller: last_name, label: "Nom")),
                          // AdaptiveItem(
                          //     content: customTextField(controller: email, label: "Email")
                          // ),
                        ],
                      ),
                    ),
                    customTextField(controller: email, label: "Email")
                  ],
                )),
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
                            .whenComplete(() => setState(
                                () => profileService.isLoading = false));
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
                const SizedBox(
                  height: 20,
                )
              ],
            )),
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
    );
  }
}
