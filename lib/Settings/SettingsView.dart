import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../Utils/Id.dart';
import '../Utils/Keys.dart';
import '../Utils/Localizations.dart';
import '../Utils/Network.dart';
import '../Utils/SectionWidget.dart';
import '../Utils/Storage.dart';
import '../Utils/Tags.dart';
import 'HistoryDialog/HistoryDialogWidget.dart';
import 'SettingsPage.dart';

class SettingsPageView extends SettingsPageState {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Section(
            title: AppLocalizations.of(context).appSettings.toUpperCase(),
            children: <Widget>[
              Text(
                AppLocalizations
                    .of(context)
                    .syncPhoneId + ': ' + Id.id,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              // Show short cut dialog option
              CheckboxListTile(
                value: showShortCutDialog,
                onChanged: (bool value) {
                  setState(() {
                    Storage.setBool(Keys.showShortCutDialog, value);
                    showShortCutDialog = value;
                  });
                },
                title: Text(AppLocalizations.of(context).showShortCutDialog),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 22.5),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        AppLocalizations.of(context).initialPage,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    // Initial page selector
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          items: pages.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: page,
                          onChanged: (p) async {
                            setState(() {
                              page = p;
                              Storage.setInt(
                                  Keys.initialPage, pages.indexOf(page));
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    child: Text(AppLocalizations.of(context).viewIntro),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/intro');
                    },
                  ),
                ),
              ),
            ],
          ),
          Section(
            title: AppLocalizations.of(context)
                .replacementPlanSettings
                .toUpperCase(),
            children: <Widget>[
              // Sort replacement plan option
              CheckboxListTile(
                value: sortReplacementPlan,
                onChanged: (bool value) {
                  setState(() {
                    Storage.setBool(Keys.sortReplacementPlan, value);
                    sortReplacementPlan = value;
                  });
                },
                title: Text(AppLocalizations.of(context).sortReplacementPlan),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              // Get replacementplan notifications option
              (Platform.isIOS || Platform.isAndroid)
                  ? CheckboxListTile(
                value: getReplacementPlanNotifications,
                onChanged: (bool value) {
                  setState(() {
                    Storage.setBool(
                        Keys.getReplacementPlanNotifications, value);
                    getReplacementPlanNotifications = value;
                    // Synchronise tags for notifications
                    syncTags();
                  });
                },
                title: Text(AppLocalizations
                    .of(context)
                    .getReplacementPlanNotifications),
              )
                  : Container(),
            ],
          ),
          Section(
              title:
              AppLocalizations
                  .of(context)
                  .unitPlanSettings
                  .toUpperCase(),
              children: <Widget>[
                // Show replacement plan in unit plan option
                CheckboxListTile(
                  value: showReplacementPlanInUnitPlan,
                  onChanged: (bool value) {
                    setState(() {
                      Storage.setBool(
                          Keys.showReplacementPlanInUnitPlan, value);
                      showReplacementPlanInUnitPlan = value;
                    });
                  },
                  title: Text(AppLocalizations.of(context)
                      .showReplacementPlanInUnitPlan),
                ),
                // Show work groups in unit plan option
                CheckboxListTile(
                  value: showWorkGroupsInUnitPlan,
                  onChanged: (bool value) {
                    setState(() {
                      Storage.setBool(Keys.showWorkGroupsInUnitPlan, value);
                      showWorkGroupsInUnitPlan = value;
                    });
                  },
                  title: Text(
                      AppLocalizations.of(context).showWorkGroupsInUnitPlan),
                ),
                // Show calendar in unit plan option
                CheckboxListTile(
                  value: showCalendarInUnitPlan,
                  onChanged: (bool value) {
                    setState(() {
                      Storage.setBool(Keys.showCalendarInUnitPlan, value);
                      showCalendarInUnitPlan = value;
                    });
                  },
                  title:
                  Text(AppLocalizations
                      .of(context)
                      .showCalendarInUnitPlan),
                ),
                // Show cafetoria in unit plan option
                CheckboxListTile(
                  value: showCafetoriaInUnitPlan,
                  onChanged: (bool value) {
                    setState(() {
                      Storage.setBool(Keys.showCafetoriaInUnitPlan, value);
                      showCafetoriaInUnitPlan = value;
                    });
                  },
                  title: Text(
                      AppLocalizations.of(context).showCafetoriaInUnitPlan),
                ),
                (grade == 'EF' || grade == 'Q1' || grade == 'Q2') &&
                    (Platform.isIOS || Platform.isAndroid)
                    ? Container(
                  margin:
                  EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Theme
                          .of(context)
                          .accentColor,
                      child:
                      Text(AppLocalizations
                          .of(context)
                          .scanUnitPlan),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context1) {
                              return AlertDialog(
                                title: Text(AppLocalizations
                                    .of(context)
                                    .scanUnitPlan),
                                content: Text(AppLocalizations
                                    .of(context)
                                    .scanUnitPlanExplanation),
                                actions: <Widget>[
                                  FlatButton(
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                    child: Text(
                                        AppLocalizations
                                            .of(context)
                                            .cancel,
                                        style: TextStyle(
                                            color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                    child: Text(
                                        AppLocalizations
                                            .of(context)
                                            .ok,
                                        style: TextStyle(
                                            color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushNamed('/scan');
                                    },
                                  )
                                ],
                              );
                            });
                      },
                    ),
                  ),
                )
                    : Container(),
                // Unit plan reset button
                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Theme.of(context).accentColor,
                      child: Text(AppLocalizations.of(context).resetUnitPlan),
                      onPressed: () async {
                        Storage.getKeys()
                            .where((key) =>
                        ((key.startsWith('unitPlan') ||
                            key.startsWith('room')) &&
                            key
                                .split('-')
                                .length >= 3 &&
                            !key.endsWith('-5')) ||
                            key.startsWith('exams'))
                            .forEach((key) {
                          Storage.remove(key);
                        });
                        syncTags();
                      },
                    ),
                  ),
                ),
              ]),
          Section(
            title: AppLocalizations.of(context).personalData.toUpperCase(),
            children: <Widget>[
              // Grade selector
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 22.5),
                child: SizedBox(
                  width: double.infinity,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      items: SettingsPageState.grades.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: grade,
                      onChanged: (grade) async {
                        if (await checkOnline == 1) {
                          setState(() {
                            Storage.setString(Keys.grade, grade);
                            // Reload app
                            Navigator.of(context).pushReplacementNamed('/');
                          });
                        } else {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content:
                              Text(AppLocalizations
                                  .of(context)
                                  .onlyOnline),
                              action: SnackBarAction(
                                label: AppLocalizations.of(context).ok,
                                onPressed: () {},
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              // Logout button
              Container(
                margin: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    child: Text(AppLocalizations.of(context).logout),
                    onPressed: () async {
                      Storage.remove(Keys.username);
                      Storage.remove(Keys.password);
                      Storage.remove(Keys.grade);
                      Storage.remove(Keys.id);
                      // Reload app
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                ),
              ),
            ],
          ),
          dev
              ? Section(
            title: AppLocalizations
                .of(context)
                .developerOptions
                .toUpperCase(),
            children: <Widget>[
              Container(
                margin:
                EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    color: Theme
                        .of(context)
                        .accentColor,
                    child: Text(AppLocalizations
                        .of(context)
                        .replacementplanVersion),
                    onPressed: () =>
                        showDialog<String>(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context1) =>
                                HistoryDialog(type: 'replacementplan')),
                  ),
                ),
              ),
              Container(
                margin:
                EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                      color: Theme
                          .of(context)
                          .accentColor,
                      child: Text(
                          AppLocalizations
                              .of(context)
                              .unitplanVersion),
                      onPressed: () =>
                          showDialog<String>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context1) =>
                                  HistoryDialog(type: 'unitplan'))),
                ),
              ),
            ],
          )
              : Container()
        ],
      ),
    );
  }
}
