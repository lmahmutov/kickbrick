import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kickbrick/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kickbrick/bluetooth_controller.dart';

class Onboarding extends StatefulWidget {
  final BluetoothController controller;

  const Onboarding(this.controller, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OnboardingState();
  }
}

class _OnboardingState extends State<Onboarding> {
  StreamSubscription messageFromBluetooth;
  StreamSubscription bluetoothConnected;
  String messageFromBLE = 'Включите Kickbrick\nи повесьте на мешок';
  bool isDeviceAdded = false;
  DeviceState _deviceState = DeviceState.isDisconnected;

  void readDevState() {
    SharedPreferences.getInstance().then((readyPrefs) {
      setState(() {
        isDeviceAdded = readyPrefs.getBool('isDeviceAdded') ?? false;
        print("Device added state $isDeviceAdded");
        if (isDeviceAdded) {
          _connectToDevice();
          messageFromBLE = "Connecting...\n";
        }
      });
    });
  }

  Future<void> _connectToDevice() async {
    await widget.controller.disconnect();
    print("Disconect task complete");
    await widget.controller.connect();
    print("Connect task complete");
  }

  @override
  void initState() {
    super.initState();
    readDevState();
    messageFromBluetooth = widget.controller.receiveData.listen((printstring) {
      setState(() {
        messageFromBLE += printstring;
      });
    });
    bluetoothConnected = widget.controller.deviceState.listen((stateData) {
      setState(() {
        _deviceState = stateData;
        print(_deviceState);
      });
    });
  }

  @override
  void dispose() {
    bluetoothConnected?.cancel();
    messageFromBluetooth?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: _onBackPressed,
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
                    "assets/images/meshok.png",
                  )),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      messageFromBLE,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      isDeviceAdded && _deviceState == DeviceState.isNotFound
                          ? RaisedButton(
                              padding: const EdgeInsets.all(4.0),
                              onPressed: () {
                                setState(() {
                                  messageFromBLE = "Reconnecting...\n";
                                });
                                print("RECONNECT BUTTON PRESSED");
                                _connectToDevice();
                              },
                              child: Text('Повторить поиск?',
                                  style: TextStyle(fontSize: 20)),
                            )
                          : Container(),
                      RaisedButton(
                        padding: const EdgeInsets.all(4.0),
                        onPressed: () async {
                          isDeviceAdded = false;
                          var result = await Navigator.of(context)
                              .pushNamed(AppRoutes.addDevicePage);
                          if (result == "Yep!") {
                            setState(() {
                              isDeviceAdded = true;
                              messageFromBLE = "Connecting...\n";
                            });
                            _connectToDevice();
                          }
                        },
                        child: Text('Добавить новое?',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ],
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
                              _deviceState == DeviceState.isConnected
                                  ? "К тренировкам"
                                  : "KickBrick не обнаружен",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 28, color: Colors.white),
                            ),
                          ],
                        )),
                    onTap: _deviceState == DeviceState.isConnected
                        ? () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.trenirovkapage);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

Future<bool> _onBackPressed() {
  return null;
}
