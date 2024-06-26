import 'dart:developer';

import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  String _title = 'Home';
  String _page = 'Home';
  final String _username = '';
  bool _useFilter =false;

  Function _filterCallback = () {};

  String get title => _title;
  String get username => _username;
  bool get useFilter => _useFilter;
  Function get filterCallback => _filterCallback;

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void updateFilter(bool useFilter) {
    _useFilter = useFilter;
    notifyListeners();
  }
  void setFilterCallback(Function filterCallback) {
    _filterCallback = filterCallback;
    notifyListeners();
  }
}