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
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GetCard(),
      )
    );
  }
}

