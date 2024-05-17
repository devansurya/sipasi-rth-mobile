import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';


class DataFetch {
  String baseUrl = 'http://192.168.1.8/sipasi-rth/api/';
  dynamic token = '';

  Future<Map<String, dynamic>?> getToken({required String email, required String pass}) async {
    try {
      final Map<String, String> fields = {
        'email': email,
        'password': pass,
      };

      final response = await http.post(Uri.parse('${baseUrl}auth/'), body: fields);
      log('email : $email');
      log(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        token = data['token'];
        return data;
      } else {
        throw Exception('Login Failed : '+jsonDecode(response.body)['error']);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<dynamic> getRthData(Map<String, dynamic> filter) async {
    // Implementation here
  }
}

