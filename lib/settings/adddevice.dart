import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:majascan/majascan.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddDevice(),
    ));

class AddDevice extends StatefulWidget {
  @override
  AddDeviceState createState() {
    return new AddDeviceState();
  }
}

class AddDeviceState extends State<AddDevice> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String result = "Для добавления отсканируйте QR код на устройстве";
  bool added = false;

  Future<void> _saveDevice(String mac) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("deviceMac", mac);
    prefs.setBool("isDeviceAdded", true);
    print("SAved device");
  }

  Future _scanQR() async {
    try {
      String qrResult = await MajaScan.startScan(
          title: "QRcode scanner",
          titleColor: Colors.amberAccent[700],
          qRCornerColor: Colors.orange,
          qRScannerColor: Colors.orange);
      setState(() {
        result = "Устройство KickBrick с серийным номером $qrResult добавлено";
        added = true;
      });
      _saveDevice(qrResult);
    } on PlatformException catch (ex) {
      if (ex.code == MajaScan.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

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
              child: Text(
                result,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        floatingActionButton: !added
            ? FloatingActionButton.extended(
                icon: Icon(Icons.camera_alt),
                label: Text("Scan"),
                onPressed: _scanQR,
              )
            : FloatingActionButton.extended(
                icon: Icon(Icons.save),
                label: Text("Save"),
                onPressed: () {
                  Navigator.pop(context, 'Yep!');
                },
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
