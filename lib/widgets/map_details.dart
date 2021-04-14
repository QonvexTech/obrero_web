import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class MapDetails extends StatelessWidget {
  final int myCrossAxis;
  final Color mapColor;
  final String coordinates;
  final String? projectName;

  const MapDetails(
      {Key? key,
      this.myCrossAxis = 2,
      this.mapColor = Colors.green,
      this.coordinates = "1234, 12345",
      this.projectName = "Project One"})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 15,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: List.generate(5, (index) {
        return GridTile(
            child: Container(
                child: Center(
                    child: Row(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: mapColor),
            ),
            SizedBox(
              width: MySpacer.small,
            ),
            Text(projectName!, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              width: MySpacer.large,
            ),
            //TODO: make styleText dynamic
            Flexible(
              child: Text(
                coordinates,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ))));
      }),
    );
  }
}
