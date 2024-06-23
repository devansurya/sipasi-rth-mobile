import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/component/Pengaduanitem.dart';

import '../../helper/Helper.dart';

class Pengaduan extends StatefulWidget {
  const Pengaduan({super.key});

  @override
  createState() => _PengaduanState();
}

class _PengaduanState extends State<Pengaduan> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataFetch.getPublicData(endpoint: 'Pengaduan'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Helper.circleIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final result = snapshot.data['data'];
          final parsedData = List<Map<String, dynamic>>.from(result);
          List<Widget> listItem = [];

          for (var dataList in parsedData) {
            var data = dataList;
            String statusColor = 'info';

            if(data['id_status_pengaduan'] == '2'){
              statusColor = 'warning';
            }
            else if(data['id_status_pengaduan'] == '3') {
              statusColor = 'success';
            }

            Widget item = PengaduanItem(
              nama: data['nama_pengadu'] ?? data['nama'] ?? '',
              id: data['id_pengaduan'] ?? '',
              jenis: data['id_pengaduan'] ?? '',
              status: data['status'] ?? '',
              tanggal: data['create_date'] ?? '',
              deskripsi: data['deskripsi_pengaduan'] ?? '',
              subject: data['subjek'] ?? '',
              statusType: statusColor,
              statusId: data['id_status_pengaduan'],
              lokasi: data['lokasi'],
              visibilitas: data['visibilitas'],
              rth: data['nama_rth'] ?? '',
              statusPublish: data['status_publish'],
            );
            listItem.add(item);
          }

          return PengaduanList(children: listItem);
        }
      },
    );
  }

}