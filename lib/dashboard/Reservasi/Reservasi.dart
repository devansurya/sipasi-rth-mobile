import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/component/ReservasiItem.dart';

import '../../app_state.dart';
import '../../helper/Helper.dart';
import '../../public/login.dart';

class Reservasi extends StatefulWidget {
  @override
  createState() => _ReservasiState();
}

class _ReservasiState  extends State<Reservasi> {

  late Future<dynamic> _myFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myFuture = DataFetch.get(endpoint: 'Reservasi');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setFilterCallback(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return FutureBuilder(future: _myFuture, builder: (context, snapshot) => builder(context, snapshot, appState));
  }

  Widget builder(context, snapshot, appState) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Helper.circleIndicator();
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Helper.empty();
    }
    else {
      if(snapshot.data == 'relog') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
      }
      final List result =  snapshot.data['data'];
      final Map userdata = appState.userData;

      if(result.isEmpty) return Helper.empty();

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
        bool _showEditDelete = false;
        if(userdata['id_user'] == data['id_user']) _showEditDelete = true;

        Widget reservasiItem = ReservasiItem(
            idRth: data['id_rth'],
            nama: data['nama'] ?? '',
            id: data['id_reservasi'],
            showEditButton: _showEditDelete,
            jenis: data['jenis_reservasi'],
            status: data['status'],
            tanggal: data['create_date'],
            tanggalReservasi: data['tanggal_reservasi'],
            deskripsi: data['deskripsi_reservasi'],
            namaRth: data['nama_rth'],
            idStatusReservasi: data['id_status_reservasi'],
            statusBadgeColor:statusColor,
            successCallback : () => _updateData(),
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

  void _updateData() {
    setState(() {
      _myFuture = DataFetch.get(endpoint: 'Reservasi');
    });
  }
}