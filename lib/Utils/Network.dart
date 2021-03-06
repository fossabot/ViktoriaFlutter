import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:viktoriaflutter/Utils/Keys.dart';
import 'package:viktoriaflutter/Utils/Storage.dart';

Duration maxTime = Duration(seconds: 4);
String apiUrl = 'https://api.vsa.2bad2c0.de';
String lookupUrl = 'api.vsa.2bad2c0.de';
String agbUrl = 'https://vsa.2bad2c0.de/agb.html';
String historyUrl = 'https://history.api.vsa.2bad2c0.de';

/// Returns 1 if the api is online, 0 if google.com is online and -1 if everthing is offline
Future<int> get checkOnline async {
  try {
    final result1 = await InternetAddress.lookup(
        lookupUrl)
        .timeout(maxTime);
    if (result1.isNotEmpty && result1[0].rawAddress.isNotEmpty) {
      return 1;
    }
    final result2 = await InternetAddress.lookup('google.com').timeout(maxTime);
    if (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) {
      return 0;
    }
    return -1;
  } on Exception catch (_) {
    return -1;
  }
}

String getUrl(String path, {bool auth = true}) {
  String authString = auth
      ? '${Storage.getString(Keys.username) ?? ''}:${Storage.getString(
      Keys.password) ?? ''}@'
      : '';
  if (path.contains('http')) return path.replaceFirst('://', '://$authString');
  if (!path.startsWith('/')) path = '/' + path;
  return '$apiUrl$path'.replaceFirst('://', '://$authString');
}

Future fetchDataAndSave(String url, String key, String defaultValue,
    {Map<String, dynamic> body,
      Duration timeout,
      bool auth = true,
      Function(bool successfully) onFinished}) async {
  if (timeout == null) {
    timeout = maxTime;
  }
  if (body == null) url = getUrl(url, auth: auth);
  try {
    dynamic response;
    if (body != null) {
      response = await post(url, body: body);
    } else {
      response = (await http.Client().get(url).timeout(timeout)).body;
    }
    if (response.contains('404 Not Found')) {
      throw "404 Not Found";
    }
    Storage.setString(key, response);
    if (onFinished != null) onFinished(true);
  } catch (e) {
    print("Error during downloading \'$key\': " + e.toString());
    if (Storage.getString(key) == null) {
      Storage.setString(key, defaultValue);
    }
    if (onFinished != null) onFinished(false);
  }
}

Future<String> fetchData(String url,
    {Duration timeout, bool auth = true}) async {
  if (timeout == null) {
    timeout = maxTime;
  }
  url = getUrl(url, auth: auth);
  try {
    final response = await http.Client().get(url).timeout(timeout);
    return response.body;
  } catch (e) {
    print("Error during fetching ($url): " + e.toString());
    return "";
  }
}

Future<String> post(String url, {dynamic body, bool auth = true}) async {
  url = getUrl(url, auth: auth);
  HttpClient httpClient = HttpClient();
  HttpClientRequest request =
      await httpClient.postUrl(Uri.parse(url)).timeout(maxTime);
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(body)));
  HttpClientResponse response = await request.close().timeout(maxTime);
  // todo - you should check the response.statusCode
  String reply = await response.transform(utf8.decoder).join().timeout(maxTime);
  httpClient.close();
  return reply;
}
