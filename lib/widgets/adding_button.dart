import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/map_service.dart';

class AddingButton extends StatelessWidget {
  final Widget? addingPage;
  final String? buttonText;

  const AddingButton(
      {Key? key, @required this.addingPage, @required this.buttonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var mapService = Provider.of<MapService>(context);
    return MaterialButton(
      color: Palette.drawerColor,
      onPressed: () {
        mapService.gesture = false;
        showDialog(
            barrierColor: Colors.black54,
            context: context,
            builder: (_) => AlertDialog(
                backgroundColor: Palette.contentBackground,
                content: addingPage));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle,
            color: Colors.white,
          ),
          SizedBox(
            width: MySpacer.small,
          ),
          Text(
            buttonText!,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
