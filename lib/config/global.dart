import 'package:flutter/material.dart';

const String api = "http://obrero.checkmy.dev/api";

//ADMIN
const String login_api = "$api/admin-login";

//PROJECT or CHANTIER
const String project_api = "$api/project/";
const String project_create_api = "$api/project/create";
const String project_update_api = "$api/project/update";
const String project_delete_api = "$api/project/remove"; //id

//CUSTOMER or CLIENT
const String customer_api = "$api/customer/";
const String customer_create_api = "$api/customer/create";
const String customer_update_api = "$api/customer/update";
const String customer_delete_api = "$api/customer/remove"; //id

//PAYMENT
const String customer_create_api_payment = "$api/customer/payment/create";
const String customer_update_api_payment = "$api/customer/payment/update";
const String customer_delete_api_payment = "$api/customer/payment/remove"; //id

//TEXT STYLE
const TextStyle transHeader = TextStyle(color: Colors.grey);
const TextStyle boldText = TextStyle(fontWeight: FontWeight.bold);
