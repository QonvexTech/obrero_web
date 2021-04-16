import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/screens/dashboard/customer/customer_screen.dart';
import 'package:uitemplate/screens/dashboard/dashboard_screen.dart';
import 'package:uitemplate/screens/dashboard/employee/employee_screen.dart';
import 'package:uitemplate/screens/dashboard/logs/log_screen.dart';
import 'package:uitemplate/screens/dashboard/project/project_add.dart';
import 'package:uitemplate/screens/dashboard/settings/general_settings.dart';
import 'package:uitemplate/screens/login/login_screen.dart';
import 'package:uitemplate/screens/splash_screen.dart';
import 'package:uitemplate/services/autentication.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/project_service.dart';
import 'package:uitemplate/services/push_notification.dart';
import 'package:uitemplate/ui_pack/children/drawer_item.dart';
import 'package:uitemplate/ui_pack/children/sub_drawer_item.dart';
import 'package:uitemplate/ui_pack/responsive_scaffold.dart';
import 'config/pallete.dart';
import 'screens/dashboard/messages/message_screen.dart';
import 'screens/dashboard/project/project_screen.dart';
import 'services/map_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MapService().checkLocationPermission();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PushNotification()),
    ChangeNotifierProvider(create: (_) => DashboardService()),
    ChangeNotifierProvider(create: (_) => Authentication()),
    ChangeNotifierProvider(create: (_) => EmployeeSevice()),
    ChangeNotifierProvider(create: (_) => ProjectProvider()),
    ChangeNotifierProvider(create: (_) => MapService()),
    ChangeNotifierProvider(create: (_) => CustomerService()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Palette.background),
        scaffoldBackgroundColor: Palette.background,
        primaryColor: Palette.drawerColor,
        accentColor: Palette.buttonsColor1,
        iconTheme: const IconThemeData(color: Colors.black),
        // fontFamily: GoogleFonts.montserrat().fontFamily,
        // textTheme: GoogleFonts.montserratTextTheme(),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => Login(),
        '/home': (context) => MyHomePage(),
        '/project/add': (context) => ProjectAdd(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // List<CustomerModel> customers =
    //     Provider.of<CustomerService>(context).customers;
    //
    try {
      Provider.of<Authentication>(context).getLocalProfile();
      PushNotification pushNotify = Provider.of<PushNotification>(context);
      return ResponsiveScaffold(
          notifications: pushNotify.notifications,
          title: Row(
            children: [
              Text(
                "LOGO",
                style: TextStyle(
                    color: Palette.drawerColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
          drawerItems: [
            DrawerItem(
                icon: Icons.dashboard, text: "Dashboard", content: DashBoard()),
            DrawerItem(
                icon: Icons.people, text: "Customers", content: Customer()),
            DrawerItem(
                icon: Icons.pin_drop_outlined,
                text: "Chantiers",
                content: Project()),
            DrawerItem(
                icon: Icons.person_pin_circle_outlined,
                text: "Employee",
                content: EmployeeScreen()),
            DrawerItem(icon: Icons.list, text: "Logs", content: LogScreen()),
            DrawerItem(
                icon: Icons.message, text: "Pushs", content: MassageScreen()),
            DrawerItem(
                icon: Icons.settings,
                text: "Préférences",
                subItems: [
                  SubDrawerItems(
                      icon: Icons.warning,
                      title: "Warning",
                      content: GeneralSettings()),
                  SubDrawerItems(
                      icon: Icons.all_out,
                      title: "General",
                      content: Container(
                        color: Colors.blueGrey,
                      ))
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
    } catch (e) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Palette.drawerColor),
        ),
      );
    }
  }
}
