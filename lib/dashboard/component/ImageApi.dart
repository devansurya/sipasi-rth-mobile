import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../api/data.dart';

class ImageApi extends StatelessWidget {
  final String Url;
  String defaultImage = '';
  bool useBaseUrl = true;
  BoxFit fit = BoxFit.cover;
  double? height;

  ImageApi({super.key, 
    required this.Url,
    this.useBaseUrl= true,
    this.fit= BoxFit.cover,
    this.defaultImage = 'assets/images/default-card.jpg',
    this.height
  });

  Future<Map<String, dynamic>> checkValid() async{

    if(Url.isEmpty) {
      return {
        'Url' : null,
        'Valid' : false
      };
    }
    final baseUrl = await DataFetch.getAssetsUrl();

    final newUrl =  (useBaseUrl) ? baseUrl+Url : Url ;

    final response = await http.get(Uri.parse(newUrl));

    if (response.statusCode == 200) {
      return {
        'Valid' : true,
        'Url' : newUrl
      };
    }
    return {
      'Valid' : false,
      'Url' : newUrl
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: checkValid(), builder:  (context, snapshot) {
      final bool isValid = snapshot.data?['Valid'] ?? false;
      if(isValid) {
        return Image.network(
            snapshot.data?['Url'],
            fit: fit,
            height: height ?? 200,
            width: double.infinity,
        );
      }
      else {
        return Image.asset(
          defaultImage,
          fit: fit,
          height: 200,
          width: double.infinity,
        );
      }
    });
  }
}