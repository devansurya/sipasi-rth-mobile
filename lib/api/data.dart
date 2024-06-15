import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:sipasi_rth_mobile/model/setting.dart';
import '../helper/database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class DataFetch {
  // String baseUrl = 'http://192.168.1.6/sipasi-rth/api/';

  Future<Map<String, dynamic>?> login({required String email, required String pass}) async {
    try {
      final Map<String, String> fields = {
        'email': email,
        'password': pass,
      };

      String baseUrl = await getBaseUrl();
      //log(baseUrl);

      final response = await http.post(Uri.parse('${baseUrl}auth/'), body: fields);
      //print(response);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final String now =DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
        log(now);
        String newToken = data['data']['token'];
        log(newToken);
        // save to local database
        var userToken = Setting(
          code: 'UserToken',
          value: newToken, // Assuming token is a String
          desc: 'Token used to get data from api',
          createDate: now
        );

        var userName = Setting(
          code: 'UserName',
          value: data['data']['user']['nama'], // Assuming token is a String
          desc: 'Username from api',
          createDate: now
        );
        var userData = Setting(
            code: 'UserData',
            value: jsonEncode(data['data']['user']), // Assuming token is a String
            desc: 'UserData from api',
            createDate: now
        );
        //updates the token in the local db
        await DB.instance.insertSetting(userToken);
        await DB.instance.insertSetting(userName);
        await DB.instance.insertSetting(userData);

        return data;
      } else {
        throw Exception('Login Failed : '+jsonDecode(response.body)['error']);
      }
    } catch (error) {
      log(error.toString());
      throw Exception(error);
    }
  }

  Future<dynamic> getRthData(String? param) async {
    try {
      String baseUrl = await getBaseUrl();
      // Fetch the token
      String token = await getToken();
      // Define the headers with the token
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
      };
      param = param ?? '';

      final response = await http.get(Uri.parse('${baseUrl}rth/$param'), headers: requestHeaders);

      if(response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        return data;
      }
      else{
        throw Exception('Login Failed : '+jsonDecode(response.body)['error']);
      }
    }
    catch(error) {
      log(error.toString());
      throw Exception(error);
    }

  }

  static Future<dynamic> getToken() async {
      return await DB.instance.getSetting('UserToken');
  }

  //check if user is already logged in before or not
  static Future<bool> checkLogin() async {
    final Map<String?, Object?> token = await DB.instance.getFullSetting('userToken');
    final DateTime now = DateTime.now();
    print(token);
    if(token['createDate'] == null) return false;
    final DateTime createDate = DateTime.parse(token['createDate'].toString()).add(const Duration(minutes: 60));
    final String? isRememberMe = await DB.instance.getSetting('UserIsRememberMe');
    if(token['code'] != null && isRememberMe!.isNotEmpty){
      return true;
    }
    return false;
  }

  static Future<String> getBaseUrl() async {
    await dotenv.load(fileName: ".env");

    return dotenv.get("API_URL") ?? 'http://192.168.1.6/sipasi-rth/api/';
  }
  static Future<String> getAssetsUrl() async {
    await dotenv.load(fileName: ".env");

    return dotenv.get("ASSETS_URL") ?? 'http://192.168.1.206/sipasi-rth/';
  }
}

