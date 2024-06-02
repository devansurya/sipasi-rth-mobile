// lib/damage_report.dart
import 'package:flutter/material.dart';

class PengaduanItem {
  final String description;
  final DateTime date;
  final String severity;

  PengaduanItem({
    required this.description,
    required this.date,
    required this.severity,
  });
}

class PengaduanItemList extends StatelessWidget {
  final List<PengaduanItem> reports;

  PengaduanItemList({required this.reports});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Description: ${reports[index].description}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Date: ${reports[index].date.toLocal()}'.split(' ')[0],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Severity: ${reports[index].severity}',
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}