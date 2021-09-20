import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/widgets/hover_effect.dart';

class AddingButton extends StatelessWidget {
  final Widget? addingPage;
  final String? buttonText;

  const AddingButton(
      {Key? key, @required this.addingPage, @required this.buttonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var mapService = Provider.of<MapService>(context);
    return OnHover(
        isAnimate: false,
        builder: (isHovered) {
          return GestureDetector(
            onTap: () {
              mapService.gesture = false;
              showDialog(
                  barrierColor: Colors.black54,
                  context: context,
                  builder: (_) => AlertDialog(
                      backgroundColor: Palette.contentBackground,
                      content: addingPage));
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black, blurRadius: isHovered ? 1 : 0)
                ],
                borderRadius: BorderRadiusDirectional.circular(3),
                color: isHovered ? Palette.drawerColor2 : Palette.drawerColor,
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/add_circle.png",
                    width: 25,
                  ),
                  SizedBox(
                    width: MySpacer.small,
                  ),
                  Text(
                    buttonText!,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          );
        });
  }
}
