import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _title = 'Home';

  String get title => _title;

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}