import 'dart:typed_data';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartApp extends StatefulWidget {
  final String tag, package;
  final Uint8List image;
  const StartApp({Key key, this.tag, this.image, this.package})
      : super(key: key);

  @override
  _StartAppState createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> with WidgetsBindingObserver {
  DateTime initial;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(seconds: 1), () {
      initial = DateTime.now();
      DeviceApps.openApp(widget.package);
      // Navigator.pop(context);
    });
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    setState(() {});
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      print("DateTime Before Starting:" +
          initial.hour.toString() +
          ":" +
          initial.minute.toString() +
          ":" +
          initial.second.toString());
      print(initial.toString());
    }
    if (state == AppLifecycleState.resumed) {
      DateTime now = DateTime.now();
      print("DateTime After Starting:" +
          now.hour.toString() +
          ":" +
          now.minute.toString() +
          ":" +
          now.second.toString());

      prefs.setString(
          "time:${widget.package}", now.difference(initial).toString());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Hero(
              tag: widget.tag,
              child: Container(
                padding: const EdgeInsets.all(6.0),
                child: Image.memory(
                  widget.image,
                  fit: BoxFit.contain,
                  width: 80.0,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.tag,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Last usage today: ${timeInfo()}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  String timeInfo() {
    try {
      return prefs.getString("time:${widget.package}").split(".")[0];
    } catch (ex) {
      return "0 Seconds";
    }
  }
}
