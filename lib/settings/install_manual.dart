import 'package:flutter/material.dart';

class InstallDeviceManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                  "assets/images/position.png",
                )),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Включите Kickbrick\nи повесьте на \nна уровне 2/3 мешка',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                InkWell(
                  child: Container(
                      height: 62,
                      color: Colors.grey,
                      alignment: Alignment(0, 0),
                      //margin: const EdgeInsets.all(1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Вернуться обратно",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ],
                      )),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
