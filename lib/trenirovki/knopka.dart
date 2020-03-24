import 'package:flutter/material.dart';

class Knopka extends StatelessWidget {
  final String assetName;
  final String textBox;
  final VoidCallback onClick;

  const Knopka({Key key, this.assetName, this.textBox, this.onClick})
      : super(key: key);

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Image.asset(
                    assetName,
                  ),
                ),
                Text(
                  textBox,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Gilroy-Semibold",
                    fontSize: 20,
                    color: Color(0xffffffff),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
