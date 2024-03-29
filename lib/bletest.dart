import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'bluetooth_controller.dart';

class BleTestPage extends StatefulWidget {
  final BluetoothController controller;

  const BleTestPage(
    this.controller, {
    Key key,
  }) : super(key: key);
  @override
  _BleTestPageState createState() => _BleTestPageState();
}

class _BleTestPageState extends State<BleTestPage> {
  ScrollController _scrollController = ScrollController();
  List<String> litems = [];
  StreamSubscription subscriptionMessage;
  int _currentValue = 0;

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    print('Init state');
    litems.add("STARTING");
    widget.controller.connect();
    subscriptionMessage = widget.controller.receiveData.listen((printstring) {
      litems.add(printstring); // Append Text to the list
      setState(() {}); // Redraw the Stateful Widget});
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    subscriptionMessage?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              'TECT BLE',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Expanded(
                child: ListView.builder(
                    reverse: false,
                    controller: _scrollController,
                    itemCount: litems.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Text(litems[index]);
                    })),
            RaisedButton(
              onPressed: () {
                widget.controller.getImudata();
              },
              child: const Text('Получение текущих моментальных ускорений',
                  style: TextStyle(fontSize: 20)),
            ),
            RaisedButton(
              onPressed: () {
                widget.controller.startUdar();
              },
              child: const Text('Выполнение удара',
                  style: TextStyle(fontSize: 20)),
            ),
            RaisedButton(
              onPressed: () {
                widget.controller.showPixels();
              },
              child: const Text('Показать зажженные точки',
                  style: TextStyle(fontSize: 20)),
            ),
            RaisedButton(
              onPressed: () {
                widget.controller.showNumber(_currentValue);
              },
              child:
                  const Text('Показать цифру', style: TextStyle(fontSize: 20)),
            ),
            NumberPicker.integer(
                initialValue: _currentValue,
                minValue: 0,
                maxValue: 9,
                onChanged: (newValue) =>
                    setState(() => _currentValue = newValue))
          ],
        ),
      ),
    );
  }
}
