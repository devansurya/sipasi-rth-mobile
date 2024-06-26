import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/public/login.dart';
import '../../app_state.dart';
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
  Container _container(appState) {
    return Container(
      height: 100,
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
              Image.asset('assets/icons/logo.png', height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      hint: Text(
                        _userName,
                        style: const TextStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ],
                      onChanged: (String? value) {
                        if (value == 'logout') {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      },
                    ),
                  ),
                  if(appState.useFilter) IconButton(onPressed: (){appState.filterCallback();}, icon: const FaIcon(FontAwesomeIcons.filter), iconSize: 14,padding: EdgeInsets.zero,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    return FutureBuilder<String?>(
      future: _cachedData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _container(appState);
        } else if (snapshot.hasError) {
          return _container(appState);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _container(appState);
        } else {
          var data = jsonDecode(snapshot.data ??'');
          _userName = data['nama'] ?? '';
          return _container(appState);
        }
      },
    );
  }
}