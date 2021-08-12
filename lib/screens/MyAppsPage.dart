import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_apps/provider/apps_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAppsPage extends StatelessWidget {
  Map appdata = new Map<String, ApplicationWithIcon>();

  MyAppsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
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
                  appdata[app.appName] = app;
                });
                var sortedKeys = appdata.keys.toList()..sort();
                return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: apps.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0),
                    itemBuilder: (context, index) {
                      return GridAppItem(app: appdata[sortedKeys[index]]);
                    });
              },
              loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
              error: (err, stl) => Center(
                    child: Text(err),
                  )),
        );
      },
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
        print("App is starting: ${app.appName} : ${app.packageName}");
        return DeviceApps.openApp(app.packageName);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Image.memory(
              app.icon,
              fit: BoxFit.contain,
              width: 40.0,
            ),
          ),
          Text(
            app.appName,
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    );
  }
}
