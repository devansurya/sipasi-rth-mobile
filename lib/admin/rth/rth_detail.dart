import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sipasi_rth_mobile/admin/component/AlertWidget.dart';
import 'package:sipasi_rth_mobile/admin/component/ImageApi.dart';
import '../../api/data.dart';
import '../pengaduan/FormPengaduan.dart';

class RthDetail extends StatefulWidget {
  final String idRth;
  RthDetail({super.key, required this.idRth});
  final data = DataFetch();

  @override
  createState() => _RthDetailState();
}

class _RthDetailState extends State<RthDetail>{
  late final String idRth;
  Widget _alert = const Visibility(visible:false, child: Text('None'));
  Widget getRthDetail(List<Map> data, BuildContext context) {
    Map dataItem = data[0];
    return Scaffold(
      appBar: AppBar(
        title: Text(dataItem['nama_rth']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
              child: ImageApi(Url: dataItem['foto_rth'],defaultImage: "assets/images/default-card.jpg", useBaseUrl: true),
            ),
            _alert,
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ///show only when the reservasi is 1
                Visibility(
                    visible: dataItem['status_reservasi'] == '1' ? true : false,
                    child: ElevatedButton(
                      onPressed: () async => Navigator.push(context, MaterialPageRoute(builder: (context) => const FormPengaduan())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        surfaceTintColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Reservasi',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    )
                ),
                const SizedBox(width: 8.0),
                Visibility(
                    visible: true ,
                    child: ElevatedButton(
                      onPressed: () async {
                        var data =  await Navigator.push(context, MaterialPageRoute(builder: (context) => FormPengaduan(id: int.parse(dataItem['id_rth']),)));
                        showSuccessAlert(data);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        surfaceTintColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Pengaduan',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              dataItem['nama_rth'],
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  Text('Status Reservasi : '),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
                    child: Container(
                      color: dataItem['status_reservasi'] == '1' ? Colors.blueAccent : Colors.red,
                      padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
                      child: Text(dataItem['status_reservasi'] == '1' ? 'Aktif' : 'Tidak Aktif', style: TextStyle(color: Colors.white),),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 8.0),
            Text(
              dataItem['deskripsi_rth'],
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Alamat:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              dataItem['alamat'],
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  void showSuccessAlert(data) {
    print(data);
    Widget newAlert = const Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
          child: AlertWidget(
              message: 'Pengaduan Anda sudah masuk dalam sistem kami. Kami akan segera memeriksanya.',
              icon: FontAwesomeIcons.thumbsUp,
              backgroundColor: Colors.green,
          ),
        )
    );
    setState(() {
      _alert = newAlert;
    });
  }

  @override
  void initState() {
    super.initState();
    idRth = widget.idRth;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: widget.data.getRthData('?id_rth=$idRth'), builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No data available'));
      }
      else {
        final result = snapshot.data['data'];
        final parsedData = List<Map<dynamic, dynamic>>.from(result);
        return getRthDetail(parsedData, context);
      }
    });
  }
}