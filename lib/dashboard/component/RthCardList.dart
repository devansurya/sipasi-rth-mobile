import 'package:sipasi_rth_mobile/dashboard/component/ImageApi.dart';
import '../../api/data.dart';
import 'package:flutter/material.dart';
import '../rth/rth_detail.dart';

class GetCard extends StatelessWidget {
  // final List<Map> data;

  final data = DataFetch();

  GetCard({super.key});
  List<Widget> getCard(List<Map> data, BuildContext context) {
    List<Column> rows = [];

    for (var element in data) {
      Card card = Card(
        elevation: 4.0,
        key: ValueKey<String>(element['id_rth']),
        surfaceTintColor: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataFetch.getRthData(''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        else {
          // print(snapshot.data['data']);
          final result = snapshot.data['data'];
          final parsedData = List<Map<dynamic, dynamic>>.from(result);
          print(parsedData);
          // return getCard(result);
          return ListView(children: getCard(parsedData, context));
        }
      },
    );

  }
}