import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sipasi_rth_mobile/admin/profile.dart';
import 'package:sipasi_rth_mobile/admin/rth.dart';
import 'package:sipasi_rth_mobile/admin/pengaduan.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

//index of admin
class Index extends StatefulWidget {
  @override
  _IndexView createState() => _IndexView();
}

class _IndexView extends State<Index> {
  static final List<Widget> _widgetOptions = <Widget>[
    Rth(),
    Pengaduan(),
    Profile()
  ];
  int _selectedIndex = 0;

  void _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(1000),
          child: Container(
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
                    Image.asset('assets/icons/logo.png',height: 50),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: const Row(
                          children: [
                            Text(
                              'name',
                              style: TextStyle(color: Colors.black), // Adjust text color if needed
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_drop_down, color: Colors.black), // Adjust icon color if needed
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
                    const SizedBox(width: 8), // Add padding to the right side
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.list),
              label: 'Rth',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.flag),
              label: 'Pengaduan',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),);
   ;
  }
}
