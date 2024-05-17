import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<StatefulWidget> createState() => DashboardView();
}

class DashboardView extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: getDataTable(data: [
          {'Name': 'ujang','kecamatan': 'tapos','kelurahan': 'tapos'}
        ]),
      ),
    );
  }
}

class getDataTable extends StatelessWidget {
  final List<Map> data;

  const getDataTable({super.key, required this.data});

  List<DataRow> getTableRows(List<Map> data) {
    List<DataRow> rows = [];
    data.forEach((element) {
      // Create a TableRow for each data item
      List<DataCell> cells = []; // List to hold cell widgets
      element.forEach((key, value) {
        cells.add(DataCell(Text(value))); // Add Text widget for each data value
      });
      cells.add(DataCell(Row(children: [
        ButtonBar(
          children: [FaIcon(FontAwesomeIcons.pencil)],
        ),
        ButtonBar(
          children: [FaIcon(FontAwesomeIcons.trash)],
        )
      ])));
      rows.add(DataRow(cells: cells));
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal,child: DataTable(columns: const <DataColumn>[
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Kecamatan')),
      DataColumn(label: Text('Kelurahan')),
      DataColumn(label: Text('Action')),
    ], rows: getTableRows(data)),);
  }
}
