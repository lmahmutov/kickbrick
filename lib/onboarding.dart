import 'package:flutter/material.dart';
import 'bletest.dart';

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.purple, Colors.orange])),
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Image.asset(
                  "assets/images/meshok.png",
                  //height: 200,
                  //fit: BoxFit.fitHeight,
                )),
                new Container(
                  height: 133.49,
                  width: 47.86,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      width: 2.00,
                      color: Color(0xff1d1d1b),
                    ),
                    borderRadius: BorderRadius.circular(8.51),
                  ),
                ),
                Text(
                  'Включите Kickbrick\nи повесьте на мешок',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                InkWell(
                  child: Container(
                      height: 50,
                      color: Colors.grey,
                      alignment: Alignment(0, 0),
                      //margin: const EdgeInsets.all(1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                          Text(
                            "Настройки",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ],
                      )),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => BleTestPage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
