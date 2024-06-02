import '../../api/data.dart';
import 'dart:developer';

import 'package:flutter/material.dart';

class GetCard extends StatelessWidget {
  // final List<Map> data;

  final data = DataFetch();
  List<Widget> getCard(List<Map> data) {
    List<Column> rows = [];
    print(data);
    log('babyyy');
    data.forEach((element) {
      print(element);
      Card card = Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.asset(
                "assets/images/default-card.jpg",
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                element['nama_rth'],
                style: const TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      );

      Column column = Column(
        children: [
          Padding(padding: const EdgeInsets.all(0.0),child: card),
        ],
      );

      rows.add(column);
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data.getRthData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }
        else {
          // print(snapshot.data['data']);
          final result = snapshot.data['data'];
          final parsedData = new List<Map<dynamic, dynamic>>.from(result);
          print(parsedData);
          // return getCard(result);
          return ListView(children: getCard(parsedData));
        }
      },
    );

  }
}