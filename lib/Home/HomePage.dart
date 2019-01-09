import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal/onesignal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Keys.dart';
import '../UnitPlan/UnitPlanData.dart';
import 'HomeView.dart';

// Define drawer item
class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

// Define page
class Page {
  IconData icon;
  String name;
  Widget page;

  Page(this.name, this.icon, this.page);
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageView();
}

abstract class HomePageState extends State<HomePage> {
  int selectedDrawerIndex = 0;
  SharedPreferences sharedPreferences;
  static String grade = '';
  bool dialogShown = false;
  bool showDialog1 = true;
  static const platform = const MethodChannel('viktoriaflutter');

  @override
  void initState() {
    loadData();
    // Update replacement plan if new message received
    OneSignal.shared.setNotificationReceivedHandler((osNotification) {
      DateTime now = DateTime.now();
      String lastUpdate = sharedPreferences.getString(Keys.lastUpdate);
      // Check if last update is longer than one minute ago
      if (lastUpdate == null ||
          now.isAfter(DateTime.parse(lastUpdate).add(Duration(minutes: 1)))) {
        // Reload app
        sharedPreferences.setString(Keys.lastUpdate, now.toIso8601String());
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
    OneSignal.shared.setNotificationOpenedHandler((osNotification) {
      platform.invokeMethod('clearNotifications');
      if (osNotification.notification.payload.body.contains('Stunde')) {
        setState(() => selectedDrawerIndex = 1);
      }
    });
    // Initialize onesignal
    OneSignal.shared.init('1d7b8ef7-9c9d-4843-a833-8a1e9999818c');
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    // Synchronise tags for notifications
    syncTags();
    super.initState();
  }

  // Load saved data
  void loadData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      grade = sharedPreferences.get(Keys.grade) ?? '';
      showDialog1 = sharedPreferences.getBool(Keys.showShortCutDialog) ?? true;
      selectedDrawerIndex = sharedPreferences.getInt(Keys.initialPage) ?? 0;
    });
  }

  // Return the widget of the page
  getDrawerItemWidget(int pos, List<Page> pages) {
    if (pos < pages.length)
      return pages[pos].page;
    else
      return Text('Error');
  }

  // Change page
  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }
}