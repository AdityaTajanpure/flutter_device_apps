import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_apps/screens/MyAppsPage.dart';
import 'package:flutter_device_apps/screens/MyHomePage.dart';
import 'package:flutter_device_apps/screens/StartApp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Show
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //Hide
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Device Apps',
        routes: {
          '/': (context) => MyHomePage(),
          '/apps': (context) => MyAppsPage(),
        },
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
      ),
    );
  }
}
