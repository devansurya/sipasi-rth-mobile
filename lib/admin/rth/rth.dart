import 'package:flutter/material.dart';
import '../component/RthCardList.dart';

class Rth extends StatefulWidget {
  const Rth({super.key});
  @override
  State<StatefulWidget> createState() => DashboardView();
}

class DashboardView extends State<Rth> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: GetCard(),
      )
    );
  }
}

