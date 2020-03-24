import 'package:flutter/material.dart';

class NastroikaVesa extends StatelessWidget {
  final int ves;
  final String vesChego;
  final VoidCallback onPlusClick;
  final VoidCallback onMinusClick;

  const NastroikaVesa(
      {Key key, this.ves, this.onPlusClick, this.onMinusClick, this.vesChego})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                vesChego,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Gilroy-Semibold",
                  fontSize: 25,
                  color: Color(0xffffffff),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30),
                child: InkWell(
                  child: Image.asset(
                    "assets/images/minus_button.png",
                    fit: BoxFit.cover,
                  ),
                  onTap: onMinusClick,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  "$ves",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Gilroy-Semibold",
                    fontSize: 25,
                    color: Color(0xffffffff),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: InkWell(
                  child: Image.asset(
                    "assets/images/plus_button.png",
                    fit: BoxFit.cover,
                  ),
                  onTap: onPlusClick,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
