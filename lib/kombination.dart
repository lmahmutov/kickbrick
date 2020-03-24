import 'package:flutter/material.dart';

class Kombination extends StatelessWidget {
  final String images;
  final VoidCallback onClick;

  const Kombination({Key key, this.images, this.onClick}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
