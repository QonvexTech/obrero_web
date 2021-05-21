import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/view/dashboard/customer/customer_screen.dart';

class DashboardService extends ChangeNotifier {
  Widget clientPage = CustomerScreen();

  DateTime? tempDate;
  int _selectedProject = 0;

  initGetId(List<ProjectModel> projects) async {
    if (projects.length > 0) {
      _selectedProject = projects[0].id!;
      initialPositon = projects[0].coordinates;
    } else {
      initialPositon = await _getPosition();
    }
  }

  Future<LatLng> _getPosition() async {
    final Location location = Location();
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) throw 'GPS service is disabled';
    }
    if (await location.hasPermission() == PermissionStatus.denied) {
      if (await location.requestPermission() != PermissionStatus.granted)
        throw 'No GPS permissions';
    }
    final data = await location.getLocation();
    return LatLng(data.latitude!, data.longitude!);
  }

  get selectedProject => _selectedProject;
  set selectedPrject(value) {
    _selectedProject = value;
    notifyListeners();
  }

  get projectPage => clientPage;

  set projectPage(value) {
    clientPage = value;
    notifyListeners();
  }
}
