import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/dashboard/component/ImageApi.dart';
import 'package:sipasi_rth_mobile/helper/Helper.dart';
import 'package:sipasi_rth_mobile/public/login.dart';
import '../../api/data.dart';
import 'package:flutter/material.dart';
import '../../app_state.dart';
import '../../helper/CustomTheme.dart';
import '../rth/Rth_detail.dart';

class RthCardList extends StatefulWidget {
  const RthCardList({super.key});
  @override
  createState() => _RthCardListState();
}

class _RthCardListState extends State<RthCardList> {
  late Future<dynamic> _myFuture;
  bool _filterIsActive = true;
  bool _filterIsNotActive = true;

  List<Widget> getCard(List<Map> data, BuildContext context) {
    List<Column> rows = [];

    for (var element in data) {
      Card card = Card(
        elevation: 4.0,
        key: ValueKey<String>(element['id_rth']),
        surfaceTintColor: Colors.white,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(8.0), // Added margin for better spacing
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
              child: ImageApi(
                Url: element['foto_rth'],
                defaultImage: "assets/images/default-card.jpg",
                useBaseUrl: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjusted padding
              child: GestureDetector(
                onTap: () {
                  final String key = element['id_rth'];
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RthDetail(idRth: key,)));
                },
                child: Text(
                  element['nama_rth'],
                  style: const TextStyle(
                    fontSize: 18.0, // Increased font size for the title
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // Improved color for better readability
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // Ensure the title stays on one line
                  semanticsLabel: 'Title', // Accessibility label
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjusted padding
              child: Text(
                element['deskripsi_rth'],
                style: const TextStyle(
                  fontSize: 14.0, // Slightly smaller font size for the description
                  color: Colors.black54, // Use a lighter color for the description
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                semanticsLabel: 'Description', // Accessibility label
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      final String key = element['id_rth'];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RthDetail(idRth: key,)));
                    },
                    child: const Text(
                      'Selengkapnya..',
                      style: TextStyle(color: Colors.green), // Button text color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      Column column = Column(
        children: [
          Padding(padding: const EdgeInsets.all(0.0),child: card),
        ],
      );

      rows.add(column);
    }
    return rows;
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
                        const Row(
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
                                  const Text(
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
                                  const Text(
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
                              _getData();
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

  void _getData() async{

    String param = '?';

    if(_filterIsActive || _filterIsNotActive) {
      param += 'statuses=';
    }

    if(_filterIsActive) {
      param +='1';
      if(_filterIsNotActive) {
        param +=',';
      }
    }
    if(_filterIsNotActive) {
      param +='"0"';
    }
    log(param);
    setState(() {
      _myFuture = DataFetch.getRthData(param);
    });

  }

  @override
  void initState() {
    super.initState();
    _myFuture = DataFetch.getRthData('');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setFilterCallback(() {
        _showFilter(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _myFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Helper.circleIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        else {
          if(snapshot.data == 'relog') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
          }
          // print(snapshot.data['data']);
          final result = snapshot.data['data'];
          final parsedData = List<Map<dynamic, dynamic>>.from(result);
          // return getCard(result);
          return ListView(children: getCard(parsedData, context));
        }
      },
    );

  }
}