import 'package:flutter/material.dart';
import 'package:kickbrick/kombination.dart';
import 'package:kickbrick/nastroikivesa.dart';
import 'package:kickbrick/trenirovka.dart';
import 'onboarding.dart';

class ReactionSpeedPage extends StatefulWidget {
  const ReactionSpeedPage({Key key, this.state}) : super(key: key);

  final ReactionSpeedPage state;

  @override
  State<StatefulWidget> createState() {
    return _ReactionSpeedPageState();
  }
}

class _ReactionSpeedPageState extends State<ReactionSpeedPage> {
  @override
  void initState() {
    super.initState();
  }

  int vesMeshka = 42;
  int vesBoica = 80;
  //final int ves_sportsmena;

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.black),
              child: Center(
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/small_logo.png",
                  ),
                ),
                NastroikaVesa(
                  ves: vesMeshka,
                  onPlusClick: () {
                    setState(() {
                      vesMeshka = vesMeshka + 1;
                    });
                  },
                  onMinusClick: () {
                    setState(() {
                      vesMeshka = vesMeshka - 1;
                    });
                  },
                  vesChego: "Вес мешка",
                ),
                NastroikaVesa(
                  ves: vesBoica,
                  onPlusClick: () {
                    setState(() {
                      vesBoica = vesBoica + 1;
                    });
                  },
                  onMinusClick: () {
                    setState(() {
                      vesBoica = vesBoica - 1;
                    });
                  },
                  vesChego: "Ваш вес",
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Комбинации",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Gilroy-Semibold",
                      fontSize: 25,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Kombination(
                      images: "assets/images/kulak.png",
                    ),
                    Kombination(
                      images: "assets/images/kulak_noga.png",
                    )
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  child: Container(
                      height: 62,
                      color: Color(0xFF3D3637),
                      alignment: Alignment(0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Как повесить KickBrick?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      )),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SecondRoute()));
                  },
                ),
                InkWell(
                  child: Container(
                      height: 62,
                      color: Color(0xFF8D8D8D),
                      alignment: Alignment(0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Выбор программы",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ],
                      )),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Trenirovka()));
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
