import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/models/color_model.dart';

// Routes
const String api = "https://obrero.checkmy.dev/api";

//WARNING
const String remove_warning = "$api/project/warning/remove/";

//ADMIN
const String login_api = "$api/admin-login";
const String add_token = "$api/add_my_token";
const String message_history = "$api/messaging/my_sentbox";
const String add_warning = "$api/project/warning/create";
const String update_color_name = "$api/colors/update_name";
const String delete_notification = "$api/notification/delete";

//PROJECT or CHANTIER
const String project_api = "$api/project/";
const String project_create_api = "$api/project/create";
const String project_status_update = "$api/project/update-status";
const String project_update_api = "$api/project/update";
const String project_delete_api = "$api/project/remove"; //id
const String project_api_date = "$api/project/date-based";

//CUSTOMER or CLIENT
const String customer_api = "$api/customer/";
const String customer_create_api = "$api/customer/create";
const String customer_update_api = "$api/customer/update/";
const String customer_delete_api = "$api/customer/remove"; //id
const String customer_projects = "$api/customer/customer_projects/";

//PAYMENT
const String customer_create_api_payment = "$api/customer/payment/create";
const String customer_update_api_payment = "$api/customer/payment/update";
const String customer_delete_api_payment = "$api/customer/payment/remove";

//USER
const String user_api = "$api/user/";
const String user_update = "$api/user/admin-update";
const String user_delete = "$api/user/delete";
const String user_register = "$api/register";
const String user_projects = "$api/project/user_projects/";

//PROJECT ASSIGN
const String remove_assign = "$api/project/remove_assign";
const String assign_user = "$api/project/assign";

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
List<ColorModels> colorsSettings = [];
List historyMessages = [];

// Base64Codec defaultImage = ""

List<ColorModels> colorsSettingsStatus = [
  ColorModels(
      id: 00000,
      color: Colors.green,
      colorName: 'green',
      name: "En cours",
      circleAsset: "assets/icons/green.png"),
  ColorModels(
      id: 00001,
      color: Colors.blue,
      colorName: 'blue',
      name: "Compléter",
      circleAsset: "assets/icons/blue.png"),
  ColorModels(
      id: 00002,
      color: Colors.grey,
      colorName: 'grey',
      name: "Annulé",
      circleAsset: "assets/icons/grey.png"),
  ColorModels(
      id: 00003,
      color: Colors.red,
      colorName: 'red',
      name: "Arrêté",
      circleAsset: "assets/icons/red.png")
];

Map<String, String> defaultImageTag = {
  "red": "assets/icons/red.png",
  "pink": "assets/icons/pink.png",
  "purple": "assets/icons/purple.png",
  "deepPurple": "assets/icons/deepPurple.png",
  "indigo": "assets/icons/indigo.png",
  "blue": "assets/icons/blue.png",
  "lightBlue": "assets/icons/lightBlue.png",
  "cyan": "assets/icons/cyan.png",
  "teal": "assets/icons/teal.png",
  "green": "assets/icons/green.png",
  "lightGreen": "assets/icons/lighGreen.png",
  "lime": "assets/icons/lighGreen.png",
  "yellow": "assets/icons/yellow.png",
  "amber": "assets/icons/amber.png",
  "orange": "assets/icons/orange.png",
  "deepOrange": "assets/icons/deepOrange.png",
  "brown": "assets/icons/brown.png",
  "grey": "assets/icons/grey.png",
  "blueGrey": "assets/icons/blueGrey.png",
  "black": "assets/icons/black.png"
};

Map<String, Color> colorMap = {
  "red": Colors.red,
  "pink": Colors.pink,
  "purple": Colors.purple,
  "deepPurple": Colors.deepPurple,
  "indigo": Colors.indigo,
  "blue": Colors.blue,
  "lightBlue": Colors.lightBlue,
  "cyan": Colors.cyan,
  "teal": Colors.teal,
  "green": Colors.green,
  "lightGreen": Colors.lightGreen,
  "lime": Colors.lime,
  "yellow": Colors.yellow,
  "amber": Colors.amber,
  "orange": Colors.orange,
  "deepOrange": Colors.deepOrange,
  "brown": Colors.brown,
  "grey": Colors.grey,
  "blueGrey": Colors.blueGrey,
  "black": Colors.black,
};

List<Map<dynamic, dynamic>> countries = [
  {"name": 'Afghanistan', "code": 'AF'},
  {"name": 'Åland Islands', "code": 'AX'},
  {"name": 'Albania', "code": 'AL'},
  {"name": 'Algeria', "code": 'DZ'},
  {"name": 'American Samoa', "code": 'AS'},
  {"name": 'AndorrA', "code": 'AD'},
  {"name": 'Angola', "code": 'AO'},
  {"name": 'Anguilla', "code": 'AI'},
  {"name": 'Antarctica', "code": 'AQ'},
  {"name": 'Argentina', "code": 'AR'},
  {"name": 'Armenia', "code": 'AM'},
  {"name": 'Aruba', "code": 'AW'},
  {"name": 'Australia', "code": 'AU'},
  {"name": 'Austria', "code": 'AT'},
  {"name": 'Azerbaijan', "code": 'AZ'},
  {"name": 'Bahamas', "code": 'BS'},
  {"name": 'Bahrain', "code": 'BH'},
  {"name": 'Bangladesh', "code": 'BD'},
  {"name": 'Barbados', "code": 'BB'},
  {"name": 'Belarus', "code": 'BY'},
  {"name": 'Belgium', "code": 'BE'},
  {"name": 'Belize', "code": 'BZ'},
  {"name": 'Benin', "code": 'BJ'},
  {"name": 'Bermuda', "code": 'BM'},
  {"name": 'Bhutan', "code": 'BT'},
  {"name": 'Bolivia', "code": 'BO'},
  {"name": 'Botswana', "code": 'BW'},
  {"name": 'Bouvet Island', "code": 'BV'},
  {"name": 'Brazil', "code": 'BR'},
  {"name": 'Brunei Darussalam', "code": 'BN'},
  {"name": 'Bulgaria', "code": 'BG'},
  {"name": 'Burkina Faso', "code": 'BF'},
  {"name": 'Burundi', "code": 'BI'},
  {"name": 'Cambodia', "code": 'KH'},
  {"name": 'Cameroon', "code": 'CM'},
  {"name": 'Canada', "code": 'CA'},
  {"name": 'Cape Verde', "code": 'CV'},
  {"name": 'Cayman Islands', "code": 'KY'},
  {"name": 'Chad', "code": 'TD'},
  {"name": 'Chile', "code": 'CL'},
  {"name": 'China', "code": 'CN'},
  {"name": 'Christmas Island', "code": 'CX'},
  {"name": 'Colombia', "code": 'CO'},
  {"name": 'Comoros', "code": 'KM'},
  {"name": 'Congo', "code": 'CG'},
  {"name": 'Cook Islands', "code": 'CK'},
  {"name": 'Costa Rica', "code": 'CR'},
  {"name": 'Cote D\'Ivoire', "code": 'CI'},
  {"name": 'Croatia', "code": 'HR'},
  {"name": 'Cuba', "code": 'CU'},
  {"name": 'Cyprus', "code": 'CY'},
  {"name": 'Czech Republic', "code": 'CZ'},
  {"name": 'Denmark', "code": 'DK'},
  {"name": 'Djibouti', "code": 'DJ'},
  {"name": 'Dominica', "code": 'DM'},
  {"name": 'Dominican Republic', "code": 'DO'},
  {"name": 'Ecuador', "code": 'EC'},
  {"name": 'Egypt', "code": 'EG'},
  {"name": 'El Salvador', "code": 'SV'},
  {"name": 'Equatorial Guinea', "code": 'GQ'},
  {"name": 'Eritrea', "code": 'ER'},
  {"name": 'Estonia', "code": 'EE'},
  {"name": 'Ethiopia', "code": 'ET'},
  {"name": 'Faroe Islands', "code": 'FO'},
  {"name": 'Fiji', "code": 'FJ'},
  {"name": 'Finland', "code": 'FI'},
  {"name": 'France', "code": 'FR'},
  {"name": 'French Guiana', "code": 'GF'},
  {"name": 'French Polynesia', "code": 'PF'},
  {"name": 'Gabon', "code": 'GA'},
  {"name": 'Gambia', "code": 'GM'},
  {"name": 'Georgia', "code": 'GE'},
  {"name": 'Germany', "code": 'DE'},
  {"name": 'Ghana', "code": 'GH'},
  {"name": 'Gibraltar', "code": 'GI'},
  {"name": 'Greece', "code": 'GR'},
  {"name": 'Greenland', "code": 'GL'},
  {"name": 'Grenada', "code": 'GD'},
  {"name": 'Guadeloupe', "code": 'GP'},
  {"name": 'Guam', "code": 'GU'},
  {"name": 'Guatemala', "code": 'GT'},
  {"name": 'Guernsey', "code": 'GG'},
  {"name": 'Guinea', "code": 'GN'},
  {"name": 'Guinea-Bissau', "code": 'GW'},
  {"name": 'Guyana', "code": 'GY'},
  {"name": 'Haiti', "code": 'HT'},
  {"name": 'Honduras', "code": 'HN'},
  {"name": 'Hong Kong', "code": 'HK'},
  {"name": 'Hungary', "code": 'HU'},
  {"name": 'Iceland', "code": 'IS'},
  {"name": 'India', "code": 'IN'},
  {"name": 'Indonesia', "code": 'ID'},
  {"name": 'Iraq', "code": 'IQ'},
  {"name": 'Ireland', "code": 'IE'},
  {"name": 'Isle of Man', "code": 'IM'},
  {"name": 'Israel', "code": 'IL'},
  {"name": 'Italy', "code": 'IT'},
  {"name": 'Jamaica', "code": 'JM'},
  {"name": 'Japan', "code": 'JP'},
  {"name": 'Jersey', "code": 'JE'},
  {"name": 'Jordan', "code": 'JO'},
  {"name": 'Kazakhstan', "code": 'KZ'},
  {"name": 'Kenya', "code": 'KE'},
  {"name": 'Kiribati', "code": 'KI'},
  {"name": 'Kuwait', "code": 'KW'},
  {"name": 'Kyrgyzstan', "code": 'KG'},
  {"name": 'Latvia', "code": 'LV'},
  {"name": 'Lebanon', "code": 'LB'},
  {"name": 'Lesotho', "code": 'LS'},
  {"name": 'Liberia', "code": 'LR'},
  {"name": 'Liechtenstein', "code": 'LI'},
  {"name": 'Lithuania', "code": 'LT'},
  {"name": 'Luxembourg', "code": 'LU'},
  {"name": 'Macao', "code": 'MO'},
  {"name": 'Madagascar', "code": 'MG'},
  {"name": 'Malawi', "code": 'MW'},
  {"name": 'Malaysia', "code": 'MY'},
  {"name": 'Maldives', "code": 'MV'},
  {"name": 'Mali', "code": 'ML'},
  {"name": 'Malta', "code": 'MT'},
  {"name": 'Marshall Islands', "code": 'MH'},
  {"name": 'Martinique', "code": 'MQ'},
  {"name": 'Mauritania', "code": 'MR'},
  {"name": 'Mauritius', "code": 'MU'},
  {"name": 'Mayotte', "code": 'YT'},
  {"name": 'Mexico', "code": 'MX'},
  {"name": 'Monaco', "code": 'MC'},
  {"name": 'Mongolia', "code": 'MN'},
  {"name": 'Montserrat', "code": 'MS'},
  {"name": 'Morocco', "code": 'MA'},
  {"name": 'Mozambique', "code": 'MZ'},
  {"name": 'Myanmar', "code": 'MM'},
  {"name": 'Namibia', "code": 'NA'},
  {"name": 'Nauru', "code": 'NR'},
  {"name": 'Nepal', "code": 'NP'},
  {"name": 'Netherlands', "code": 'NL'},
  {"name": 'New Caledonia', "code": 'NC'},
  {"name": 'New Zealand', "code": 'NZ'},
  {"name": 'Nicaragua', "code": 'NI'},
  {"name": 'Niger', "code": 'NE'},
  {"name": 'Nigeria', "code": 'NG'},
  {"name": 'Niue', "code": 'NU'},
  {"name": 'Norfolk Island', "code": 'NF'},
  {"name": 'Norway', "code": 'NO'},
  {"name": 'Oman', "code": 'OM'},
  {"name": 'Pakistan', "code": 'PK'},
  {"name": 'Palau', "code": 'PW'},
  {"name": 'Panama', "code": 'PA'},
  {"name": 'Papua New Guinea', "code": 'PG'},
  {"name": 'Paraguay', "code": 'PY'},
  {"name": 'Peru', "code": 'PE'},
  {"name": 'Philippines', "code": 'PH'},
  {"name": 'Pitcairn', "code": 'PN'},
  {"name": 'Poland', "code": 'PL'},
  {"name": 'Portugal', "code": 'PT'},
  {"name": 'Puerto Rico', "code": 'PR'},
  {"name": 'Qatar', "code": 'QA'},
  {"name": 'Reunion', "code": 'RE'},
  {"name": 'Romania', "code": 'RO'},
  {"name": 'RWANDA', "code": 'RW'},
  {"name": 'Saint Helena', "code": 'SH'},
  {"name": 'Saint Lucia', "code": 'LC'},
  {"name": 'Samoa', "code": 'WS'},
  {"name": 'San Marino', "code": 'SM'},
  {"name": 'Saudi Arabia', "code": 'SA'},
  {"name": 'Senegal', "code": 'SN'},
  {"name": 'Seychelles', "code": 'SC'},
  {"name": 'Sierra Leone', "code": 'SL'},
  {"name": 'Singapore', "code": 'SG'},
  {"name": 'Slovakia', "code": 'SK'},
  {"name": 'Slovenia', "code": 'SI'},
  {"name": 'Solomon Islands', "code": 'SB'},
  {"name": 'Somalia', "code": 'SO'},
  {"name": 'South Africa', "code": 'ZA'},
  {"name": 'Spain', "code": 'ES'},
  {"name": 'Sri Lanka', "code": 'LK'},
  {"name": 'Sudan', "code": 'SD'},
  {"name": 'Suri"name"', "code": 'SR'},
  {"name": 'Swaziland', "code": 'SZ'},
  {"name": 'Sweden', "code": 'SE'},
  {"name": 'Switzerland', "code": 'CH'},
  {"name": 'Tajikistan', "code": 'TJ'},
  {"name": 'Thailand', "code": 'TH'},
  {"name": 'Timor-Leste', "code": 'TL'},
  {"name": 'Togo', "code": 'TG'},
  {"name": 'Tokelau', "code": 'TK'},
  {"name": 'Tonga', "code": 'TO'},
  {"name": 'Tunisia', "code": 'TN'},
  {"name": 'Turkey', "code": 'TR'},
  {"name": 'Turkmenistan', "code": 'TM'},
  {"name": 'Tuvalu', "code": 'TV'},
  {"name": 'Uganda', "code": 'UG'},
  {"name": 'Ukraine', "code": 'UA'},
  {"name": 'United Kingdom', "code": 'GB'},
  {"name": 'United States', "code": 'US'},
  {"name": 'Uruguay', "code": 'UY'},
  {"name": 'Uzbekistan', "code": 'UZ'},
  {"name": 'Vanuatu', "code": 'VU'},
  {"name": 'Venezuela', "code": 'VE'},
  {"name": 'Viet Nam', "code": 'VN'},
  {"name": 'Wallis and Futuna', "code": 'WF'},
  {"name": 'Western Sahara', "code": 'EH'},
  {"name": 'Yemen', "code": 'YE'},
  {"name": 'Zambia', "code": 'ZM'},
  {"name": 'Zimbabwe', "code": 'ZW'}
];

// List<NotificationModel> notificationList = [];
extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

//Location
LatLng initialPositon = LatLng(48.864716, 2.349014);

//DATES
List months = [
  "",
  'Janvier',
  'Février',
  'Mars',
  'Avril',
  'Mai',
  'Juin',
  'Juillet',
  'Août',
  'Septembre',
  'Octobre',
  'Novembre',
  'Décembre'
];
