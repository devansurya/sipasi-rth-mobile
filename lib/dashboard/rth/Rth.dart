import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/helper/CustomTheme.dart';
import 'package:sipasi_rth_mobile/helper/Helper.dart';
import '../../app_state.dart';
import '../component/RthCardList.dart';

class Rth extends StatefulWidget {
  const Rth({super.key});
  @override
  State<StatefulWidget> createState() => DashboardView();
}

class DashboardView extends State<Rth> {

  bool _filterIsActive = false;
  bool _filterIsNotActive = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //set onclick
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setFilterCallback(() {
        _showFilter(context);
      });
    });
  }

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Status Reservasi',
                              style: TextStyle(
                                color: CustomTheme.textPrimaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _filterIsActive = !_filterIsActive;
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _filterIsActive,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterIsActive = value ?? false;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Aktif',
                                    style: TextStyle(
                                      color: CustomTheme.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _filterIsNotActive = !_filterIsNotActive;
                                });
                              },
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _filterIsNotActive,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterIsNotActive = value ?? false;
                                      });
                                    },
                                  ),
                                  Text(
                                    'Tidak Aktif',
                                    style: TextStyle(
                                      color: CustomTheme.textSecondaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Helper.button(
                            'Filter',
                            callback: () {
                              // Implement your filter logic here
                              Navigator.pop(context); // Close the bottom sheet
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


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

