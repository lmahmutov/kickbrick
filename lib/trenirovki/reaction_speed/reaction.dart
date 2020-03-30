import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kickbrick/routes.dart';
import 'package:kickbrick/settings/nastroikivesa.dart';
import 'package:kickbrick/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kickbrick/bluetooth_controller.dart';

class ReactionSpeed extends StatefulWidget {
  final BluetoothController controller;

  const ReactionSpeed(this.controller, {Key key, this.state}) : super(key: key);

  final ReactionSpeed state;

  @override
  State<StatefulWidget> createState() {
    return _ReactionSpeedState();
  }
}

class _ReactionSpeedState extends State<ReactionSpeed> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  StreamSubscription dataRecieved;
  Timer timer;
  int workTime;
  int restTime;

  Future<void> _saveworkTime() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("workTime", workTime);
  }

  Future<void> _saverestTime() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt("restTime", restTime);
  }

  void startTimer() {
    // Start the periodic timer which prints something every 1 seconds
    timer = Timer.periodic(new Duration(seconds: 4), (time) {
      print('Timeout ожидания удара');
      widget.controller.startUdar();
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((readyPrefs) {
      setState(() {
        workTime = readyPrefs.getInt('workTime') ?? 60;
        restTime = readyPrefs.getInt('restTime') ?? 10;
      });
    });
    dataRecieved = widget.controller.notificationData.listen((data) {
      if (data[0] == 2 && data[2] != 0) {
        print("Start");
        timer.cancel();
        dataRecieved?.cancel();
        Navigator.of(context).pushNamed(AppRoutes.startCheckReaction);
      } else {
        print(data);
      }
    });
    startTimer();
  }

  @override
  void dispose() {
    dataRecieved?.cancel();
    timer.cancel();
    super.dispose();
  }

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
                  ves: workTime,
                  onPlusClick: () {
                    _saveworkTime();
                    setState(() {
                      workTime = workTime + 1;
                    });
                  },
                  onMinusClick: () {
                    _saveworkTime();
                    setState(() {
                      workTime = workTime - 1;
                    });
                  },
                  vesChego: "Время тренировки",
                ),
                NastroikaVesa(
                  ves: restTime,
                  onPlusClick: () {
                    _saverestTime();
                    setState(() {
                      restTime = restTime + 1;
                    });
                  },
                  onMinusClick: () {
                    _saverestTime();
                    setState(() {
                      restTime = restTime - 1;
                    });
                  },
                  vesChego: "Интервал отдыха",
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Image.asset(
                    "assets/images/start_udar.png",
                  ),
                ),
                Text(
                  ' Для старта ударьте по мешку',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  child: Container(
                      height: 62,
                      color: Color(0xFF8D8D8D),
                      alignment: Alignment(0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Настройки",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ],
                      )),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsPage()));
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
