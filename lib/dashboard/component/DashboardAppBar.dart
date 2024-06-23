import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../helper/database.dart';

class DashboardAppBarWidget extends StatefulWidget {
  @override
  createState() => _DashboardAppBarWidgetState();
}

class _DashboardAppBarWidgetState extends State<DashboardAppBarWidget> {
  Future<String?> _cachedData = DB.instance.getSetting('UserData');
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _cachedData = DB.instance.getSetting('UserData');
  }
  Container _container() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/icons/logo.png', height: 50),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  icon: Row(
                    children: [
                      Text(
                        _userName,
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value == 'logout') {
                      // Handle logout
                      print('User logged out');
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _cachedData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _container();
        } else if (snapshot.hasError) {
          return _container();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _container();
        } else {
          var data = jsonDecode(snapshot.data ??'');
          _userName = data['nama'] ?? '';
          return _container();
        }
      },
    );
  }
}