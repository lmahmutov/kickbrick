import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kickbrick/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kickbrick/bluetooth_controller.dart';

class StartCheckReaction extends StatefulWidget {
  final BluetoothController controller;

  const StartCheckReaction(this.controller, {Key key, this.state})
      : super(key: key);

  final StartCheckReaction state;

  @override
  State<StatefulWidget> createState() {
    return _StartCheckReactionState();
  }
}

class _StartCheckReactionState extends State<StartCheckReaction> {
  StreamSubscription dataRecieved;
  Timer timer;
  int workTime;
  int restTime;
  int count = 0;

  void startTimer() {
    // Start the periodic timer which prints something every 1 seconds
    timer = Timer.periodic(new Duration(seconds: 1), (time) {
      print('Timeout');
      setState(() {
        workTime--;
      });
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
        print("Udar poluchen");
        setState(() {
          count++;
        });
        widget.controller.startUdar();
      } else {
        print(data);
        widget.controller.startUdar();
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
          alignment: Alignment.center,
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
                Text(
                  workTime.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Image.asset(
                    "assets/images/start_udar.png",
                  ),
                ),
                Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 150.0,
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
