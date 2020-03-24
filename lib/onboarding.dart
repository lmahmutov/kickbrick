import 'package:flutter/material.dart';
import 'package:kickbrick/routes.dart';

class Onboarding extends StatelessWidget {
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
                )),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Включите Kickbrick\nи повесьте на мешок',
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
                            "Далее",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ],
                      )),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.trenirovkapage);
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
