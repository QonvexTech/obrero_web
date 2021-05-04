import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/firebase_message.dart';
import 'package:uitemplate/services/message_service.dart';
import 'package:uitemplate/services/profile_service.dart';
import 'package:uitemplate/services/project/project_add_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/ui_pack/children/drawer_item.dart';
import 'package:uitemplate/ui_pack/children/sub_drawer_item.dart';
import 'package:uitemplate/ui_pack/responsive_scaffold.dart';
import 'package:uitemplate/view/dashboard/customer/customer_screen.dart';
import 'package:uitemplate/view/dashboard/dashboard_screen.dart';
import 'package:uitemplate/view/dashboard/employee/employee_screen.dart';
import 'package:uitemplate/view/dashboard/logs/log_screen.dart';
import 'package:uitemplate/view/dashboard/messages/message_screen.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';
import 'package:uitemplate/view/dashboard/project/project_screen.dart';
import 'package:uitemplate/view/dashboard/settings/general_settings.dart';
import 'package:uitemplate/view/dashboard/settings/warning_settings.dart';
import 'package:uitemplate/view/login/login_screen.dart';
import 'package:uitemplate/view/splash_screen.dart';
import 'config/pallete.dart';
import 'services/map_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MapService().checkLocationPermission();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FireBase()),
    ChangeNotifierProvider(create: (_) => DashboardService()),
    ChangeNotifierProvider(create: (_) => EmployeeSevice()),
    ChangeNotifierProvider(create: (_) => ProjectProvider()),
    ChangeNotifierProvider(create: (_) => ProjectAddService()),
    ChangeNotifierProvider(create: (_) => MapService()),
    ChangeNotifierProvider(create: (_) => PaginationService()),
    ChangeNotifierProvider(create: (_) => CustomerService()),
    ChangeNotifierProvider(create: (_) => MessageService()),
    ChangeNotifierProvider(create: (_) => ProfileService()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obrero Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Palette.background),
        scaffoldBackgroundColor: Palette.background,
        primaryColor: Palette.drawerColor,
        accentColor: Palette.buttonsColor1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      home: SplashScreen(),
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => Login(),
        '/home': (context) => MyHomePage(),
        '/project/add': (context) => ProjectAddScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Image.asset(
            'assets/icons/logo.png',
            height: 50,
          ),
        ),
        drawerItems: [
          DrawerItem(
              icon: Icons.dashboard,
              text: "Dashboard",
              content: DashBoardScreen()),
          DrawerItem(
              icon: Icons.people, text: "Customers", content: CustomerScreen()),
          DrawerItem(
              icon: Icons.pin_drop_outlined,
              text: "Chantiers",
              content: ProjectScreen()),
          DrawerItem(
              icon: Icons.person_pin_circle_outlined,
              text: "Employee",
              content: EmployeeScreen()),
          DrawerItem(icon: Icons.list, text: "Logs", content: LogScreen()),
          DrawerItem(
              icon: Icons.message, text: "Pushs", content: MessageScreen()),
          DrawerItem(
              icon: Icons.settings,
              text: "Préférences",
              subItems: [
                SubDrawerItems(
                    icon: Icons.warning,
                    title: "Warning",
                    content: WarningSettings()),
                SubDrawerItems(
                    icon: Icons.all_out,
                    title: "General",
                    content: GeneralSettings())
              ],
              content: Container(
                color: Colors.red,
              )),
        ],
        drawerBackgroundColor: Palette.drawerColor,
        backgroundColor: Palette.contentBackground,
        body: Container(
          color: Colors.black,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              for (var x = 1; x < 20; x++) ...{
                GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue),
                    height: 150,
                  ),
                )
              }
            ],
          ),
        ));
  }
}
