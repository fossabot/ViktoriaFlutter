import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Keys.dart';
import '../Localizations.dart';
import '../Cafetoria/CafetoriaPage.dart';
import '../Calendar/CalendarPage.dart';
import '../Courses/CoursesPage.dart';
import '../ReplacementPlan/ReplacementPlanPage.dart';
import '../Settings/SettingsPage.dart';
import '../UnitPlan/UnitPlanPage.dart';
import '../WorkGroups/WorkGroupsView.dart';
import '../Messageboard/MessageboardView.dart';
import 'HomePage.dart';
import 'ShortCutDialog/ShortCutDialogWidget.dart';

class HomePageView extends HomePageState {
  @override
  Widget build(BuildContext context) {
    // List of pages
    List<Page> pages = [
      Page(AppLocalizations.of(context).unitPlan, Icons.event_note,
          UnitPlanPage()),
      Page(AppLocalizations.of(context).replacementPlan,
          Icons.format_list_numbered, ReplacementPlanPage()),
      Page(AppLocalizations.of(context).messageboard, Icons.message,
          MessageboardPage()),
      Page(AppLocalizations.of(context).calendar, Icons.calendar_today,
          CalendarPage()),
      Page(AppLocalizations.of(context).cafetoria, Icons.fastfood,
          CafetoriaPage()),
      Page(AppLocalizations.of(context).workGroups, MdiIcons.soccer,
          WorkGroupsPage()),
      Page(AppLocalizations.of(context).courses, Icons.person, CoursesPage()),
      Page(AppLocalizations.of(context).settings, Icons.settings,
          SettingsPage()),
    ];

    // Map pages to drawer items
    List<DrawerItem> drawerItems =
        pages.map((Page page) => DrawerItem(page.name, page.icon)).toList();

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
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        bool selectedSubjects = sharedPreferences.getKeys().where((key) {
              if (key.startsWith(
                  '${Keys.unitPlan}${sharedPreferences.getString(Keys.grade)}-')) {
                if ('-'.allMatches(key).length == 3)
                  return key.split('-')[key.split('-').length - 1] != '5';
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
        }
      });
    }

    appScaffold = Scaffold(
      appBar: AppBar(
        // Current page's title
        title: Text(drawerItems[selectedDrawerIndex].title),
        elevation: 0.0,
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
      body: getDrawerItemWidget(selectedDrawerIndex, pages),
    );
    return appScaffold;
  }

}
