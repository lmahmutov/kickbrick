import 'dart:async';
import 'package:convert/convert.dart';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothController {
  StreamController<String> _receivedData = StreamController();
  Stream<String> get receiveData => _receivedData.stream;
  var device;
  bool _connected = false;
  bool _scanstarted = false;
  BluetoothCharacteristic _commandCharacteristic;

  Future connect() async {
    if (!_connected && !_scanstarted) {
      _scanstarted = true;
      await FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));
      FlutterBlue.instance.scanResults.listen((scanResults) async {
        for (ScanResult scanResult in scanResults) {
          String name = scanResult.device.name;
          print("name $name");
          _receivedData.add("Found device $name");
          if (name.startsWith("KickBrick")) {
            device = scanResult.device;
            FlutterBlue.instance.stopScan();
            await device.connect();
            print("KICKBRICK Connected");
            _receivedData.add("KICKBRICK Connected");
            _connected = true;
            getservices();
          }
        }
        _scanstarted = false;
      });
    }
  }

  Future getservices() async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      if (service.uuid.toString().startsWith("0000fff0")) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          print(c.uuid.toString());
          if (c.uuid.toString().startsWith("0000fff1")) {
            print("Command Characteristic found");
            _commandCharacteristic = c;
            _receivedData.add("Command Characteristic found");
          } else if (c.uuid.toString().startsWith("0000fff2")) {
            print("Answer Characteristic found");
            _receivedData.add("Answer Characteristic found");
            await c.setNotifyValue(true);
            c.value.listen((value) {
              var resultnotif = hex.encode(value);
              _receivedData.add(resultnotif);
            });
          }
        }
      }
    });
  }

  Future<void> getImudata() async {
    if (_connected) {
      _receivedData.add("Получение текущих моментальных ускорений");
      await _commandCharacteristic.write([
        0x01,
        0x02,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
        0x09,
        0x10,
        0x01,
        0x02,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
      ]);
    }
  }

  Future<void> startUdar() async {
    if (_connected) {
      _receivedData.add("Выполнение удара");
      await _commandCharacteristic.write([
        0x02,
        0x01,
        0x01,
        0x01,
        0x05,
        0x06,
        0x07,
        0x08,
        0x09,
        0x10,
        0x01,
        0x02,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
      ]);
    }
  }

  Future<void> showPixels() async {
    if (_connected) {
      _receivedData.add("Показать зажженные точки");
      await _commandCharacteristic.write([
        0x03,
        0x05,
        0x02,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
        0x09,
        0x10,
        0x01,
        0x02,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
      ]);
    }
  }

  Future<void> showNumber(int _number) async {
    if (_connected) {
      _receivedData.add("Показать цифру $_number");
      await _commandCharacteristic.write([
        0x04,
        _number,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
        0x09,
        0x10,
        0x01,
        0x02,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
      ]);
    }
  }

  void dispose() {
    _scanstarted = false;
    _receivedData.close();
    _connected = false;
    FlutterBlue.instance.stopScan();
    device?.disconnect();
  }
}
