import 'package:flutter/material.dart';
import 'package:uitemplate/models/admin_model.dart';

const String api = "https://obrero.checkmy.dev/api";

//ADMIN
const String login_api = "$api/admin-login";

//PROJECT or CHANTIER
const String project_api = "$api/project/";
const String project_create_api = "$api/project/create";
const String project_update_api = "$api/project/update";
const String project_delete_api = "$api/project/remove"; //id
const String project_api_date = "$api/project/date-based";

//CUSTOMER or CLIENT
const String customer_api = "$api/customer/";
const String customer_create_api = "$api/customer/create";
const String customer_update_api = "$api/customer/update/";
const String customer_delete_api = "$api/customer/remove"; //id

//PAYMENT
const String customer_create_api_payment = "$api/customer/payment/create";
const String customer_update_api_payment = "$api/customer/payment/update";
const String customer_delete_api_payment = "$api/customer/payment/remove";

//USER
const String user_api = "$api/user/";
const String user_update = "$api/user/admin-update";
const String user_delete = "$api/user/delete";
const String user_register = "$api/register";

//CHANGEPASSWORD
const String change_password_api = "$api/user/change-password";

//MESSAGING
const String message_send_api = "$api/messaging/send";
const String firebase_messaging = "https://fcm.googleapis.com/fcm/send";

//HOURS
const String projectTotalHours = "$api/project/hours/";

//TEXT STYLE
const TextStyle transHeader = TextStyle(color: Colors.grey);
const TextStyle boldText = TextStyle(fontWeight: FontWeight.bold);

//GLOBAL
String? authToken;
Admin? profileData;
List<Color> statusColors = [
  Colors.greenAccent,
  Colors.yellowAccent,
  Colors.redAccent,
  Colors.blueAccent
];
List<String> statusTitles = ['En cours', 'En attente', 'Annulé', 'Compléter'];
List<String> imagesStatus = [
  "assets/icons/green.png",
  "assets/icons/green.png"
];
// List<NotificationModel> notificationList = [];
