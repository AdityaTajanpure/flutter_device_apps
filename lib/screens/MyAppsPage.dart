import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_apps/provider/apps_state.dart';
import 'package:flutter_device_apps/screens/StartApp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAppsPage extends StatelessWidget {
  Map appdata = new Map<String, ApplicationWithIcon>();

  MyAppsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future(() {
        Navigator.pushNamed(context, '/');
        return true;
      }),
      child: Consumer(
        builder: (context, watch, _) {
          final appsInfo = watch(appsProvider);
          return Scaffold(
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.black.withOpacity(0.7),
              leading: BackButton(
                color: Colors.white,
              ),
            ),
            body: appsInfo.when(
                data: (List<Application> apps) {
                  apps.forEach((element) {
                    ApplicationWithIcon app = element;
                    appdata[app.appName.toLowerCase()] = app;
                  });
                  var sortedKeys = appdata.keys
                      .map((e) => e.toString().toLowerCase())
                      .toList()
                        ..sort();
                  return Container(
                    child: GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: apps.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0),
                        itemBuilder: (context, index) {
                          return GridAppItem(app: appdata[sortedKeys[index]]);
                        }),
                  );
                },
                loading: () => Center(
                      child: CircularProgressIndicator(),
                    ),
                error: (err, stl) => Center(
                      child: Text(err),
                    )),
          );
        },
      ),
    );
  }
}

class GridAppItem extends StatelessWidget {
  final ApplicationWithIcon app;
  const GridAppItem({Key key, @required this.app}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartApp(
              tag: app.appName,
              image: app.icon,
              package: app.packageName,
            ),
          ),
        );
        print("App is starting: ${app.appName} : ${app.packageName}");
        // return DeviceApps.openAppSettings(app.packageName);
      },
      child: Column(
        children: [
          Hero(
            tag: app.appName,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              child: Image.memory(
                app.icon,
                fit: BoxFit.contain,
                width: 50.0,
              ),
            ),
          ),
          Text(getName(app.appName)),
        ],
      ),
    );
  }

  String getName(String app) {
    if (app.length < 10) {
      return app;
    } else {
      return app.substring(0, 7) + "...";
    }
  }
}
