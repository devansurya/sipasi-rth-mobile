import 'package:flutter/material.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/component/ReservasiItem.dart';

import '../../helper/Helper.dart';

class Reservasi extends StatefulWidget {
  @override
  createState() => _ReservasiState();
}

class _ReservasiState  extends State<Reservasi> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataFetch.get(endpoint: 'Reservasi'), builder: (context, snapshot) => builder(context, snapshot));
  }

  Widget builder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Helper.circleIndicator();
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No data available'));
    }
    else {
      final result = snapshot.data['data'];
      final parsedData = List<Map<String, dynamic>>.from(result);
      List<Widget> listItem = [];

      for (var dataList in parsedData) {
        Map<String, dynamic>data = dataList;
        String statusColor = 'info';

        if(data['id_status_reservasi'] == '1'){
          statusColor = 'warning';
        }
        else if(data['id_status_reservasi'] == '2') {
          statusColor = 'success';
        }
        else if(data['id_status_reservasi'] == '3') {
          statusColor = 'error';
        }
        else if(data['id_status_reservasi'] == '4') {
          statusColor = 'error';
        }



        Widget reservasiItem = ReservasiItem(
            idRth: data['id_rth'],
            nama: data['nama'] ?? '',
            id: data['id_reservasi'],
            jenis: data['jenis_reservasi'],
            status: data['status'],
            tanggal: data['create_date'],
            tanggalReservasi: data['tanggal_reservasi'],
            deskripsi: data['deskripsi_reservasi'],
            namaRth: data['nama_rth'],
            idStatusReservasi: data['id_status_reservasi'],
            statusBadgeColor:statusColor
        );

        listItem.add(reservasiItem);
      }

      return Scaffold(
        backgroundColor: Colors.grey[200],
        body: ListView(
          children: listItem,
        ),
      );
    }
  }
}