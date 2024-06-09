import 'package:flutter/material.dart';
import 'package:sipasi_rth_mobile/admin/component/ImageApi.dart';

import '../api/data.dart';

class RthDetail extends StatelessWidget {
  final String idRth;
  RthDetail({super.key, required this.idRth});
  final data = DataFetch();

  Widget getRthDetail(List<Map> data, BuildContext context) {
    Map dataItem = data[0];
    return Scaffold(
      appBar: AppBar(
        title: Text(dataItem['nama_rth']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
              child: ImageApi(Url: dataItem['foto_rth'],defaultImage: "assets/images/default-card.jpg", useBaseUrl: true),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add action for 'Pengaduan' button
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    surfaceTintColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Reservasi',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Add action for 'Reservasi' button
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                    surfaceTintColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Pengaduan',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              dataItem['nama_rth'],
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 8.0),
            Text(
              dataItem['deskripsi_rth'],
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Alamat:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              dataItem['alamat'],
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: data.getRthData('?id_rth=${idRth}'), builder: (context, snapshot){

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No data available'));
      }
      else {
        final result = snapshot.data['data'];
        final parsedData = new List<Map<dynamic, dynamic>>.from(result);
        // print(parsedData);

        return getRthDetail(parsedData, context);
      }
    });
  }

}