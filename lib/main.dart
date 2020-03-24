import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:kickbrick/bletest.dart';
import 'package:kickbrick/onboarding.dart';
import 'package:kickbrick/routes.dart';
import 'bluetooth_controller.dart';

BluetoothController controller = new BluetoothController();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        AppRoutes.testScreen: (context) => BleTestPage(controller),
        AppRoutes.seCondScreen: (context) => SecondRoute()
      },
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return MyHomePage(
                title: 'kickbrick',
                bluetoothController: controller,
              );
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatefulWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  State<StatefulWidget> createState() {
    return _BluetoothOffScreenState();
  }
}

class _BluetoothOffScreenState extends State<BluetoothOffScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${widget.state.toString()}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.bluetoothController}) : super(key: key);
  final String title;
  final BluetoothController bluetoothController;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(showOnBoarding);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF000000),
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
          ),
        ),
        child: Center(
          child: Image.asset("assets/images/logo_fon.png"),
        ),
      ),
    );
  }

  Future<void> showOnBoarding(Duration timeStamp) async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushNamed(AppRoutes.seCondScreen);
  }
}
