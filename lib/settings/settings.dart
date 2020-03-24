import 'package:flutter/material.dart';
import 'package:kickbrick/kombination.dart';
import 'package:kickbrick/routes.dart';
import 'package:kickbrick/settings/nastroikivesa.dart';
import 'package:kickbrick/trenirovki/trenirovka.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key, this.state}) : super(key: key);

  final SettingsPage state;

  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isKulakSelected = true;
  int vesMeshka;
  int vesBoica;

  Future<void> _saveVesMeshka() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("vesMeshka", vesMeshka);
  }

  Future<void> _saveVesBoica() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("vesBoica", vesBoica);
  }

  Future<void> _savekombination() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("isKulakSelected", isKulakSelected);
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((readyPrefs) {
      print("LOADEDE");
      setState(() {
        vesMeshka = readyPrefs.getInt('vesMeshka') ?? 40;
        vesBoica = readyPrefs.getInt('vesBoica') ?? 50;
        isKulakSelected = readyPrefs.getBool('isKulakSelected') ?? true;
      });
    });
  }

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
                    _saveVesMeshka();
                    setState(() {
                      vesMeshka = vesMeshka + 1;
                    });
                  },
                  onMinusClick: () {
                    _saveVesMeshka();
                    setState(() {
                      vesMeshka = vesMeshka - 1;
                    });
                  },
                  vesChego: "Вес мешка",
                ),
                NastroikaVesa(
                  ves: vesBoica,
                  onPlusClick: () {
                    _saveVesBoica();
                    setState(() {
                      vesBoica = vesBoica + 1;
                    });
                  },
                  onMinusClick: () {
                    _saveVesBoica();
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
                        selected: isKulakSelected,
                        onClick: () {
                          setState(() {
                            isKulakSelected = true;
                          });
                          _savekombination();
                        }),
                    Kombination(
                      images: "assets/images/kulak_noga.png",
                      selected: !isKulakSelected,
                      onClick: () {
                        _savekombination();
                        setState(
                          () {
                            isKulakSelected = false;
                          },
                        );
                      },
                    ),
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
                    Navigator.of(context).pushNamed(AppRoutes.installPage);
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
