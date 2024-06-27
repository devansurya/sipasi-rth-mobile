import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sipasi_rth_mobile/dashboard/Reservasi/Reservasi.dart';
import 'package:sipasi_rth_mobile/dashboard/component/DashboardAppBar.dart';
import 'package:sipasi_rth_mobile/dashboard/Profile.dart';
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
  late var appState;
  @override
  static final List<Widget> _widgetOptions = <Widget>[
    const Rth(),
    const Pengaduan(),
    Home(useAppbar: false),
    Reservasi(),
    const Profile()
  ];

  static final List<bool> _useFilter = [
    true,
    true,
    false,
    true,
    false
  ];

  int _selectedIndex = 2;

  void _onItemTapped(index, appState) {
    appState.updateFilter(_useFilter[index]);
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
          preferredSize: const Size.fromHeight(1500),
          child: DashboardAppBarWidget(),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 12.0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey.withOpacity(0.8),
          selectedItemColor: Colors.green,
          showUnselectedLabels: true,
          selectedFontSize: 14.0,
          unselectedFontSize: 12.0,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.tree),
              label: 'Rth',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.exclamationTriangle),
              label: 'Pengaduan',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.calendarCheck),
              label: 'Reservasi',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userCircle),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {_onItemTapped(index, appState);},
        ),
        ),
    );
  }
}
