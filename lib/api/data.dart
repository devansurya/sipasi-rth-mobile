import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:sipasi_rth_mobile/model/setting.dart';
import '../helper/database.dart';


class DataFetch {
  String baseUrl = 'http://192.168.1.2/sipasi-rth/api/';

  Future<Map<String, dynamic>?> login({required String email, required String pass}) async {
    try {
      final Map<String, String> fields = {
        'email': email,
        'password': pass,
      };

      final response = await http.post(Uri.parse('${baseUrl}auth/'), body: fields);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        String newToken = data['data']['token'];
        // save to local database
        var userToken = Setting(
          code: 'UserToken',
          value: newToken, // Assuming token is a String
          desc: 'Token used to get data from api',
        );

        await DB.instance.insertSetting(userToken);

        return data;
      } else {
        throw Exception('Login Failed : '+jsonDecode(response.body)['error']);
      }
    } catch (error) {
      log(error.toString());
      throw Exception(error);
    }
  }

  Future<dynamic> getRthData() async {
    try {
      // Fetch the token
      String token = await getToken();

      // Define the headers with the token
      Map<String, String> requestHeaders = {
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(Uri.parse('${baseUrl}rth/'), headers: requestHeaders);

      if(response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // log('got : ');
        // print(data);

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

}

