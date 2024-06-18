import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sipasi_rth_mobile/dashboard/component/DashboardAppBar.dart';
import 'package:sipasi_rth_mobile/dashboard/profile.dart';
import 'package:sipasi_rth_mobile/dashboard/rth/rth.dart';
import 'package:sipasi_rth_mobile/dashboard/pengaduan/pengaduan.dart';
import 'package:provider/provider.dart';

import '../public/Home.dart';
import '../app_state.dart';

//index of admin
class Index extends StatefulWidget {
  const Index({super.key});

  @override
  _IndexView createState() => _IndexView();
}

class _IndexView extends State<Index> {
  static final List<Widget> _widgetOptions = <Widget>[
    const Rth(),
    const Pengaduan(),
    Home(useAppbar: false),
    const Profile()
  ];
  int _selectedIndex = 2;

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
        backgroundColor: Colors.transparent, // Set Scaffold background to transparent
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(1000),
          child: DashboardAppBarWidget(),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10.0,
          unselectedItemColor: Colors.black.withOpacity(0.6), // A
          showUnselectedLabels: true,// djust opacity or color
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold), // Adjust text style
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
              icon: FaIcon(FontAwesomeIcons.house, ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        )
        ),
    );
  }
}
