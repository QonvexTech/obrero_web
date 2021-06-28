import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/firebase_message.dart';
import 'package:uitemplate/services/message_service.dart';
import 'package:uitemplate/services/profile_service.dart';
import 'package:uitemplate/services/project/project_add_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/scaffold_service.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/ui_pack/responsive_scaffold.dart';
import 'package:uitemplate/view/dashboard/dashboard_screen.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';
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
    ChangeNotifierProvider(create: (_) => ScaffoldService()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en'), const Locale('fr')],
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
        "home": (context) => ResponsiveScaffold(),
        '/project/add': (context) => ProjectAddScreen(),
        'dashboard': (context) => DashBoardScreen(),
      },
    );
  }
}
