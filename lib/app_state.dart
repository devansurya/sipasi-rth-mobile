import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _title = 'Home';
  final String _username = '';

  String get title => _title;
  String get username => _username;

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}