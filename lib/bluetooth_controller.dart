import 'dart:async';
import 'package:convert/convert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothController {
  StreamController<String> _receivedData = StreamController();
  Stream<String> get receiveData => _receivedData.stream;
  StreamController<DeviceState> _deviceState = StreamController();
  Stream<DeviceState> get deviceState => _deviceState.stream;

  var device;
  bool _connected = false;
  bool _scanstarted = false;

  BluetoothCharacteristic _commandCharacteristic;
  BluetoothCharacteristic _notifyCharacteristic;
  StreamSubscription scaning;
  StreamSubscription getConnectionState;
  StreamSubscription getNotification;

  Future connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _savedMac = (prefs.getString('deviceMac') ?? "");
    print("Saved MAC: $_savedMac");
    if (!_connected && !_scanstarted) {
      _scanstarted = true;
      await FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
      scaning = FlutterBlue.instance.scanResults.listen((scanResults) async {
        for (ScanResult scanResult in scanResults) {
          String name = scanResult.device.name;
          String mac = scanResult.device.id.toString();
          print("mac: $mac, device name $name");
          //if (name.startsWith("KickBrick")) {
          if (mac == _savedMac) {
            _receivedData.add("Found device $name\n");
            device = scanResult.device;
            FlutterBlue.instance.stopScan();
            await device.connect();
            getConnectionState = device.state.listen((state) {
              print('connection state: $state');
              if (state == BluetoothDeviceState.disconnected) {
                _deviceState.add(DeviceState.isDisconnected);
              }
            });
            print("KickBrick Connected");
            _receivedData.add("KickBrick Connected\n");
            _connected = true;
            _deviceState.add(DeviceState.isConnected);
            getservices();
          }
        }
        if (!_connected) {
          _deviceState.add(DeviceState.isNotFound);
        }
        _scanstarted = false;
      });
    }
  }

  Future disconnect() async {
    scaning?.cancel();
    getConnectionState?.cancel();

    if (_connected) {
      getNotification?.cancel();
      await _notifyCharacteristic?.setNotifyValue(false);
      await device?.disconnect();
    }
    _connected = false;
    _deviceState.add(DeviceState.isDisconnected);
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
            //_receivedData.add("Command Characteristic found\n");
          } else if (c.uuid.toString().startsWith("0000fff2")) {
            print("Answer Characteristic found");
            _notifyCharacteristic = c;
            //_receivedData.add("Answer Characteristic found\n");
            await _notifyCharacteristic.setNotifyValue(true);
            getNotification = _notifyCharacteristic.value.listen((value) {
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
    disconnect();
  }
}

enum DeviceState { isConnected, isDisconnected, isNotFound }
