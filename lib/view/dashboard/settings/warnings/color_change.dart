import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/services/settings/color_change_service.dart';

class ColorChange extends StatefulWidget {
  final Color? defColor;
  final int? index;

  const ColorChange({Key? key, required this.defColor, required this.index})
      : super(key: key);

  @override
  _ColorChangeState createState() => _ColorChangeState();
}

class _ColorChangeState extends State<ColorChange> {
  Color? pickerColor;
  Color? currentColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    pickerColor = widget.defColor;
    currentColor = widget.defColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorService = Provider.of<ColorChangeService>(context);
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
                // child: ColorPicker(
                //   pickerColor: pickerColor!,
                //   onColorChanged: changeColor,
                //   showLabel: true,
                //   pickerAreaHeightPercent: 0.8,
                // ),
                // Use Material color picker:
                //
                // child: MaterialPicker(
                //   pickerColor: pickerColor,
                //   onColorChanged: changeColor,
                //   showLabel: true, // only on portrait mode
                // ),
                //
                // Use Block color picker:
                //
                child: BlockPicker(
                  pickerColor: currentColor!,
                  onColorChanged: changeColor,
                ),
                //
                // child: MultipleChoiceBlockPicker(
                //   pickerColors: currentColors,
                //   onColorsChanged: changeColors,
                // ),
              ),
              actions: <Widget>[
                MaterialButton(
                  child: const Text('Appliquer'),
                  onPressed: () {
                    setState(() {
                      currentColor = pickerColor;
                      colorService.changeColor(currentColor, widget.index);
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
