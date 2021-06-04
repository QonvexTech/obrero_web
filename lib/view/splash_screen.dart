import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/caching.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/project/project_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void init() async {
    await DataCacher().getCredentials(context);
  }

  @override
  void initState() {
    this.init();
    var projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    if (projectProvider.projects != null) {
      Provider.of<DashboardService>(context, listen: false)
          .initGetId(projectProvider.projectsDateBase);
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Palette.drawerColor),
      ),
    );
  }
}
