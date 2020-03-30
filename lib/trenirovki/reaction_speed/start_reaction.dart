import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:kickbrick/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kickbrick/bluetooth_controller.dart';

class StartCheckReaction extends StatefulWidget {
  final BluetoothController controller;
  final AssetsAudioPlayer _assetsAudioPlayer;

  const StartCheckReaction(
    this.controller,
    this._assetsAudioPlayer, {
    Key key,
    this.state,
  }) : super(key: key);

  final StartCheckReaction state;

  @override
  State<StatefulWidget> createState() {
    return _StartCheckReactionState();
  }
}

class _StartCheckReactionState extends State<StartCheckReaction> {
  StreamSubscription dataRecieved;
  Timer timer, timer3, timerWork;
  int workTime;
  int restTime;
  int count = 0;
  int time321 = 3;
  bool workStarted = false;
  var _random = new Random();
  int next(int min, int max) => min + _random.nextInt(max - min);

  void timerShow321() {
    timer3 = Timer.periodic(new Duration(seconds: 1), (time) async {
      if (time321 > 0) {
        await widget.controller.showNumber(time321);
        time321--;
      } else {
        print("WORK STarted");
        timer3.cancel();
        startWorkTimer();
        workStarted = true;
        await widget.controller.startUdar();
        widget._assetsAudioPlayer.open(
          "assets/audios/box.mp3",
        );
        widget._assetsAudioPlayer.play();
      }
    });
  }

  void workTimer() {
    int _interval = next(700, 1500);
    timerWork = Timer(Duration(milliseconds: _interval), () {
      print("интервал между ударами $_interval");
      widget.controller.startUdar();
    });
  }

  void startWorkTimer() {
    timer = Timer.periodic(new Duration(seconds: 1), (time) {
      if (workTime == 0) {
        widget._assetsAudioPlayer.stop();
        timer.cancel();
      } else {
        workTime--;
        setState(() {});
      }
      print(workTime);
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
      if (workTime > 0 && workStarted) {
        if (data[0] == 2 && data[2] != 0) {
          print("Udar poluchen");
          setState(() {
            count++;
          });
          workTimer();
        } else {
          print(data);
          workTimer();
        }
      } else {}
    });
    timerShow321();
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
                RaisedButton(onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.showResultat);
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
