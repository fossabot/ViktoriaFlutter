import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ReplacementPlanView.dart';

class ReplacementPlanPage extends StatefulWidget {
  @override
  ReplacementPlanPageView createState() => ReplacementPlanPageView();
}

abstract class ReplacementPlanPageState extends State<ReplacementPlanPage> {
  SharedPreferences sharedPreferences;
  static List<String> grades = [
    '5a',
    '5b',
    '5c',
    '6a',
    '6b',
    '6c',
    '7a',
    '7b',
    '7c',
    '8a',
    '8b',
    '8c',
    '9a',
    '9b',
    '9c',
    'EF',
    'Q1',
    'Q2'
  ];

  @override
  void initState() {
    SharedPreferences.getInstance().then((instance) {
      setState(() {
        sharedPreferences = instance;
      });
    });
    super.initState();
  }
}