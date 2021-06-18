import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/color_model.dart';
import 'package:uitemplate/services/colors_service.dart';

class ColorChange extends StatefulWidget {
  final ColorModels? colorModel;
  final int? index;

  const ColorChange({
    Key? key,
    required this.colorModel,
    required this.index,
  }) : super(key: key);

  @override
  _ColorChangeState createState() => _ColorChangeState();
}

class _ColorChangeState extends State<ColorChange> {
  Color? pickerColor;
  Color? currentColor;

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  @override
  void initState() {
    pickerColor = widget.colorModel!.color;
    currentColor = widget.colorModel!.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.circle,
          color: currentColor,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Choisis une couleur!'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: currentColor!,
                  onColorChanged: changeColor,
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  child: const Text('Appliquer'),
                  onPressed: () {
                    setState(() {
                      currentColor = pickerColor;
                      colorsService
                          .updateColor(
                              colorId: widget.colorModel!.id!,
                              color:
                                  "Colors.${colorMap.keys.firstWhere((k) => colorMap[k] == currentColor, orElse: () => "")}")
                          .whenComplete(() async {
                        await colorsService.getColors.then((va) {
                          colorsSettings = va!;

                          print("Lengh Is ${colorsSettings.length}");
                        });
                      });
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
