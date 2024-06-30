import 'dart:developer';

import 'package:flutter/material.dart';

/// Ini App level state
/// bisa dipanggil dmn aja, kecuali saat build.
/// Cth : final appState = Provider.of<AppState>(context);
class AppState extends ChangeNotifier {
  String _title = 'Home';
  String _page = 'Home';
  final String _username = '';
  bool _useFilter =false;
  Map<String, dynamic> _userData = {};

  Function _filterCallback = () {};

  String get title => _title;
  String get username => _username;
  bool get useFilter => _useFilter;
  Function get filterCallback => _filterCallback;

  Map<String, dynamic> get userData => _userData;

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void setUserData(Map<String, dynamic> userData) {
    _userData = userData;
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