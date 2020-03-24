import 'package:flutter/material.dart';
import 'package:kickbrick/routes.dart';
import 'reaction_speed.dart';
import 'knopka.dart';

class Trenirovka extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.purple, Colors.orange],
              ),
            )),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Начать тренировку",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Gilroy-Semibold",
                          fontSize: 30,
                          color: Color(0xffffffff),
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Knopka(
                          assetName: "assets/images/clock.png",
                          textBox: "Скорость\nреакции",
                          onClick: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReactionSpeedPage()));
                          },
                        ),
                      ),
                      Expanded(
                        child: Knopka(
                          assetName: "assets/images/grusha_mini.png",
                          textBox: "Тренировка\nс мешком",
                          onClick: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReactionSpeedPage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Knopka(
                          assetName: "assets/images/kulak.png",
                          textBox: "Количество\nударов",
                          onClick: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReactionSpeedPage()));
                          },
                        ),
                      ),
                      Expanded(
                        child: Knopka(
                          assetName: "assets/images/chelovek.png",
                          textBox: "Комбинации\nударов",
                          onClick: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReactionSpeedPage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  child: Container(
                      height: 62,
                      color: Colors.grey,
                      alignment: Alignment(0, 0),
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
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ],
                      )),
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.testScreen);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
