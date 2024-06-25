import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sipasi_rth_mobile/public/login.dart';
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
                child: DropdownButton2<String>(
                  hint: Text(
                    _userName,
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                      onTap: () {
                      },
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value == 'logout') {
                      print('User logged out');
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                ),
              ),
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