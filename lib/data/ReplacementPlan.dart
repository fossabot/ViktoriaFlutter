import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Keys.dart';
import '../models/ReplacementPlan.dart';

Future download() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String _grade = sharedPreferences.getString(Keys.grade);
  await downloadDay(sharedPreferences, _grade, "today");
  await downloadDay(sharedPreferences, _grade, "tomorrow");

  ReplacementPlan.days = await fetchDays();
  for (int i = 0; i < 2; i++)
    ReplacementPlan.days[i]
        .insertInUnitPlan(await SharedPreferences.getInstance());
}

Future downloadDay(SharedPreferences sharedPreferences, String _grade,
    String _day) async {
  try {
    String _url = 'https://api.vsa.lohl1kohl.de/vp/' +
        _day +
        '/' +
        _grade +
        '.json?v=' +
        new Random().nextInt(99999999).toString();
    print(_url);
    final response = await http.Client().get(_url);
    await sharedPreferences.setString(
        Keys.replacementPlan + _grade + _day, response.body);
    await sharedPreferences.commit();
  } catch (e) {
    print("Error in download: " + e.toString());
    if (sharedPreferences.getString(Keys.replacementPlan + _grade + _day) ==
        null) {
      await sharedPreferences.setString(
          Keys.replacementPlan + _grade + _day, '[]');
      await sharedPreferences.commit();
    }
  }
}

List<ReplacementPlanDay> getReplacementPlan() {
  return ReplacementPlan.days;
}

Future<List<ReplacementPlanDay>> fetchDays() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String _grade = sharedPreferences.getString(Keys.grade);
  return parseDays(
      sharedPreferences.getString(Keys.replacementPlan + _grade + "today"),
      sharedPreferences.getString(Keys.replacementPlan + _grade + "tomorrow"));
}

List<ReplacementPlanDay> parseDays(String _today, String _tomorrow) {
  final today = json.decode(_today);
  final tomorrow = json.decode(_tomorrow);

  return [
    ReplacementPlanDay.fromJson(today),
    ReplacementPlanDay.fromJson(tomorrow)
  ];
}
