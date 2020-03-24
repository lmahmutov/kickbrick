import 'package:flutter/material.dart';

class Kombination extends StatelessWidget {
  final String images;
  final VoidCallback onClick;
  final bool selected;

  const Kombination({Key key, this.images, this.onClick, this.selected})
      : super(key: key);

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: InkWell(
            onTap: onClick,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white),
              ),
              child: Image.asset(
                images,
              ),
            ),
          ),
        ),
        selected
            ? Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 30.0,
                ),
              )
            : Container(),
      ],
    );
  }
}
