import 'package:flutter/material.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/component/ImageApi.dart';
import 'package:sipasi_rth_mobile/helper/Helper.dart';

import '../../helper/CustomTheme.dart';

class DetailPengaduan extends StatefulWidget {
  final String idPengaduan;
  final String idUser;
  DetailPengaduan({
    super.key,
    required this.idPengaduan,
    this.idUser='',
  });
  @override
  createState() => _DetailPengaduanState();
}

class _DetailPengaduanState extends State<DetailPengaduan> {
  initState(){
    super.initState();
  }

  builder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Helper.circleIndicator();
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data.isEmpty) {
      return const Center(child: Text('No data available'));
    } else {
      final result = snapshot.data['data'];
      final data = Map<String, dynamic>.from(result);

      String statusColor = 'info';
      if(data['id_status_pengaduan'] == '2'){
        statusColor = 'warning';
      }
      else if(data['id_status_pengaduan'] == '3') {
        statusColor = 'success';
      }

      return Scaffold(
        appBar: AppBar(surfaceTintColor: Colors.white,title: Text('Detail Pengaduan'),),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0), bottom: Radius.circular(10.0)),
                child: ImageApi(Url: data['foto'],useBaseUrl: true,defaultImage: "assets/images/default-card.jpg",),
              ),
              Text(
                data['subjek'],
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Text(
                      data['jenis_pengaduan'],
                      style: const TextStyle(fontSize: 16, color: CustomTheme.textSecondaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const Text(
                      'Status : ',
                      style: TextStyle(fontSize: 16, color: CustomTheme.textPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    Helper.badge(text: data['status'], type: statusColor)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 10),
                child: CustomTheme.activeText('Oleh : ${data['nama_pengadu'] ?? data['nama'] ?? ''} |  ${Helper.formatDate(data['create_date'],format: 'dd-MM-yyyy HH:mm:ss')}'),),
              Text(
                data['deskripsi_pengaduan'],
                style: const TextStyle(
                  fontSize: 16.0,
                  color: CustomTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              const Text(
                'RTH : ',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                data['nama_rth'] ?? '',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: CustomTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Lokasi : ',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                data['lokasi'],
                style: const TextStyle(
                  fontSize: 16.0,
                  color: CustomTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataFetch.get(endpoint: 'pengaduan',param: 'id_pengaduan=${widget.idPengaduan}' ), builder: (context, snapshot) => builder(context, snapshot));
  }

}

