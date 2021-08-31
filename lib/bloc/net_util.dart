import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart' as dot;
import 'package:http/http.dart' as http;
import 'package:monitorlibrary/auth/app_auth.dart';
import 'package:monitorlibrary/functions.dart';

class NetUtil {
  static String? activeURL;
  static bool isDevelopmentStatus = true;
  static String? url;
  static Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  static Future ping() async {
    String? mURL = await getUrl();
    var result = await _callWebAPIGet(mURL! + 'ping');
    pp('DataAPI: 🔴 🔴 🔴 ping: $result');
  }

  static Future _callWebAPIPost(String mUrl, Map? bag) async {
    pp('\n\n🏈 🏈 🏈 🏈 🏈 NetUtil_callWebAPIPost:  🔆 🔆 🔆 🔆 calling : 💙  $mUrl  💙 ');
    var mBag;
    if (bag != null) {
      mBag = json.encode(bag);
    }
    pp(' 🏈 🏈 Bag after json decode call, check properties of mBag:  🏈 🏈 $mBag');
    var start = DateTime.now();
    var client = new http.Client();
    var token = await AppAuth.getAuthToken();
    pp('❤️️❤️  DataAPI._callWebAPIPost .... token: ❤️ $token ❤️');
    headers['Authorization'] = 'Bearer $token';

    var resp = await client
        .post(
          Uri.parse(mUrl),
          body: mBag,
          headers: headers,
        )
        .whenComplete(() {});
    if (resp.statusCode == 200) {
      pp('❤️️❤️  DataAPI._callWebAPIPost .... : 💙💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
    } else {
      pp('👿👿👿 DataAPI._callWebAPIPost .... : 🔆 statusCode: 👿👿👿 ${resp.statusCode} 🔆🔆🔆 for $mUrl');
      throw Exception(
          '🚨 🚨 Status Code 🚨 ${resp.statusCode} 🚨 ${resp.body}');
    }
    var end = DateTime.now();
    pp('❤️❤️ 💙 DataAPI._callWebAPIPost ### 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
    pp(resp.body);
    try {
      var mJson = json.decode(resp.body);
      pp('❤️❤️ 💙 DataAPI._callWebAPIPost ,,,,,,,,,,,,,,,,,,, do we get here?');
      return mJson;
    } catch (e) {
      pp("👿👿👿👿👿👿👿 json.decode failed, returning response body");
      return resp.body;
    }
  }

  static Future _callWebAPIGet(String mUrl) async {
    pp('\n🏈 🏈 🏈 🏈 🏈 DataAPI_callWebAPIGet:  🔆 🔆 🔆 🔆 calling : 💙  $mUrl  💙');
    var start = DateTime.now();
    var client = new http.Client();
    var token = await AppAuth.getAuthToken();
    pp('🏈 🏈 🏈 🏈 🏈️  DataAPI._callWebAPIGet .... token: 💙️ $token 💙');
    headers['Authorization'] = 'Bearer $token';
    pp('🏈 🏈 🏈 🏈 🏈  DataAPI._callWebAPIGet .... :  😡  😡  😡 check the headers for the auth token: 💙 💙 💙 $headers 💙 💙 💙 ');
    var resp = await client
        .get(
          Uri.parse(mUrl),
          headers: headers,
        )
        .whenComplete(() {});

    pp('🏈 🏈 🏈 🏈 🏈  DataAPI._callWebAPIGet .... : 💙 statusCode: 👌👌👌 ${resp.statusCode} 👌👌👌 💙 for $mUrl');
    var end = DateTime.now();
    pp('🏈 🏈 🏈 🏈 🏈  DataAPI._callWebAPIGet ### 🔆 elapsed: ${end.difference(start).inSeconds} seconds 🔆 \n\n');
    sendError(resp);
    var mJson = json.decode(resp.body);
    return mJson;
  }

  static void sendError(http.Response resp) {
    if (resp.statusCode != 200) {
      var msg =
          '😡 😡 The response is not 200; it is ${resp.statusCode}, NOT GOOD, throwing up !! 🥪 🥙 🌮  😡 ${resp.body}';
      pp(msg);
      throw Exception(msg);
    }
  }

  static Future<String?> getUrl() async {
    if (url == null) {
      pp('🐤🐤🐤🐤 Getting url via .env settings: ${url == null ? 'NO URL YET' : url}');
      String? status = dot.dotenv.env['status'];
      pp('🐤🐤🐤🐤 DataAPI: getUrl: Status from .env: $status');
      if (status == 'dev') {
        isDevelopmentStatus = true;
        url = dot.dotenv.env['devURL'];
        pp(' 🌎 🌎 🌎 DataAPI: Status of the app is  DEVELOPMENT 🌎 🌎 🌎 $url');
        return url;
      } else {
        isDevelopmentStatus = false;
        url = dot.dotenv.env['prodURL'];
        pp(' 🌎 🌎 🌎 DataAPI: Status of the app is PRODUCTION 🌎 🌎 🌎 $url');
        return url;
      }
    } else {
      return url;
    }
  }
}
