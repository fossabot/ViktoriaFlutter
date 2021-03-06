import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Cafetoria/CafetoriaPage.dart';
import '../Calendar/CalendarPage.dart';
import '../Courses/CoursesPage.dart';
import 'package:viktoriaflutter/Utils/Keys.dart';
import 'package:viktoriaflutter/Utils/Localizations.dart';
import '../ReplacementPlan/ReplacementPlanPage.dart';
import '../Settings/SettingsPage.dart';
import 'package:viktoriaflutter/Utils/Storage.dart';
import '../UnitPlan/UnitPlanPage.dart';
import '../WorkGroups/WorkGroupsPage.dart';
import 'HomePage.dart';
import 'OfflineWidget.dart';
import 'ShortCutDialog/ShortCutDialogWidget.dart';

class HomePageView extends HomePageState {
  @override
  Widget build(BuildContext context) {
    // List of pages
    List<Page> pages = [
      Page(AppLocalizations.of(context).unitPlan, Icons.event_note,
          UnitPlanPage(),
          url:
          'https://${Storage.getString(Keys.username)}:${Storage.getString(Keys
              .password)}@www.viktoriaschule-aachen.de/sundvplan/sps/index.html'),
      Page(AppLocalizations.of(context).replacementPlan,
          Icons.format_list_numbered, ReplacementPlanPage(),
          url:
          'https://${Storage.getString(Keys.username)}:${Storage.getString(Keys
              .password)}@www.viktoriaschule-aachen.de/sundvplan/vps/index.html'),
      Page(AppLocalizations.of(context).calendar, Icons.calendar_today,
          CalendarPage()),
      Page(AppLocalizations.of(context).cafetoria, Icons.fastfood,
          CafetoriaPage(),
          url: 'https://www.opc-asp.de/vs-aachen/'),
      Page(AppLocalizations.of(context).workGroups, MdiIcons.soccer,
          WorkGroupsPage()),
      Page(AppLocalizations.of(context).courses, Icons.person, CoursesPage()),
      Page(AppLocalizations.of(context).settings, Icons.settings,
          SettingsPage()),
    ];

    // Map pages to drawer items
    List<DrawerItem> drawerItems = pages
        .map((Page page) => DrawerItem(page.name, page.icon, page.url))
        .toList();

    // Create list of widget options
    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(
          d.title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        selected: i == selectedDrawerIndex,
        onTap: () => onSelectItem(i),
      ));
    }
    // Only show the dialog only at the opening
    if (!dialogShown) {
      dialogShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        bool selectedSubjects = Storage.getKeys().where((key) {
          if (key
              .startsWith('unitPlan-${Storage.getString(Keys.grade)}-')) {
            if ('-'
                .allMatches(key)
                .length == 3)
              return key.split('-')[key
                  .split('-')
                  .length - 1] != '5';
            return true;
          }
          return false;
        }).length >
            0;
        // Check if user selected anything in the unit plan (setup)
        if (selectedSubjects) {
          // Check if short cut dialog enabled
          if (showDialog1) {
            showDialog<String>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context1) {
                  return ShortCutDialog(
                    items: drawerItems,
                    selectItem: onSelectItem,
                  );
                });
          }
        } else {
          String grade = Storage.getString(Keys.grade);
          if ((grade == 'EF' || grade == 'Q1' || grade == 'Q2') &&
              (Platform.isIOS || Platform.isAndroid)) {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context1) {
                  return AlertDialog(
                    title: Text(AppLocalizations
                        .of(context)
                        .scanUnitPlan),
                    content: Text(
                        AppLocalizations
                            .of(context)
                            .scanUnitPlanExplanation),
                    actions: <Widget>[
                      FlatButton(
                        color: Theme
                            .of(context)
                            .accentColor,
                        child: Text(AppLocalizations
                            .of(context)
                            .cancel,
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        color: Theme
                            .of(context)
                            .accentColor,
                        child: Text(AppLocalizations
                            .of(context)
                            .ok,
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/scan');
                        },
                      )
                    ],
                  );
                });
          }
        }
      });
    }

    appScaffold = Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // Current page's title
        title: FlatButton(
          padding: EdgeInsets.only(left: 0),
          child: Text(drawerItems[selectedDrawerIndex].title,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          onPressed: () => launchURL(drawerItems[selectedDrawerIndex].url),
        ),
        elevation: 0.0,
        actions: <Widget>[
          showWeek
              ? Container(
            margin: EdgeInsets.all(10),
            child: OutlineButton(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
                color: Colors.white,
                highlightedBorderColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Text(
                  currentWeek,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onPressed: weekPressed),
          )
              : Container()
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  // Logo
                  GestureDetector(
                    onTap: logoClick,
                    child: Container(
                      height: 100.0,
                      child: SvgPicture.asset(
                        'assets/images/logo_white.svg',
                      ),
                    ),
                  ),
                  // Grade
                  Text(
                    HomePageState.grade,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            // Drawer options
            Column(children: drawerOptions)
          ],
        ),
      ),
      // Current page
      body: Stack(
        children: <Widget>[
          !offlineShown ? OfflineWidget() : Container(),
          getDrawerItemWidget(selectedDrawerIndex, pages),
        ],
      ),
    );
    if (!offlineShown) {
      offlineShown = true;
    }
    return appScaffold;
  }
}
