import 'package:flutter/material.dart';
import 'package:sipasi_rth_mobile/helper/CustomTheme.dart';
import 'package:sipasi_rth_mobile/helper/Helper.dart';
import '../component/RthCardList.dart';

class Rth extends StatefulWidget {
  const Rth({super.key});
  @override
  State<StatefulWidget> createState() => DashboardView();
}

class DashboardView extends State<Rth> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //set onclick

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: RthCardList(),
      )
    );
  }
}

