import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/caching.dart';

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
