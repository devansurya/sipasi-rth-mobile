import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/Reservasi/BuktiReservasi.dart';
import 'package:sipasi_rth_mobile/helper/CustomTheme.dart';

import '../../app_state.dart';
import '../../helper/Helper.dart';
import '../component/ImageApi.dart';

class DetailReservasi extends StatelessWidget {
  final String idReservasi;
  final TextStyle _secondaryText =
      const TextStyle(fontSize: 14, color: CustomTheme.textPrimaryColor);
  final TextStyle _primaryText = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: CustomTheme.textPrimaryColor);

  DetailReservasi({super.key, required this.idReservasi});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context,listen: false);
    return FutureBuilder(
        future: DataFetch.get(
            endpoint: 'reservasi', param: 'id_reservasi=$idReservasi'),
        builder: (context, snapshot) => _builder(context, snapshot, appState));
  }

  Widget _builder(context, snapshot, appState) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Helper.circleIndicator();
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No data available'));
    } else {
      Map<String, dynamic> userdata = appState.userData;

      Map<String, dynamic> data = snapshot.data['data'];

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

      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Detail Reservasi'),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Informasi Pemesan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    const Divider(height: 5),
                    ///Name
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Nama Lengkap',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(data['nama'],
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Email',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(data['email'],
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Nomor Telepon',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(data['no_telp'] ?? '-',
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
            ///main
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Detail Reservasi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    const Divider(height: 5,),
                    ///Name
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Tanggal Reservasi',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(Helper.formatDate(data['tanggal_reservasi'], fromFormat: 'yyyy-MM-dd'),
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Nama Rth',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(data['nama_rth'],
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                      child:  ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        child: ImageApi(
                          Url: data['foto_rth'],
                          defaultImage: "assets/images/default-card.jpg",
                          useBaseUrl: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Fasilitas',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(data['nama_fasilitas'] ?? '',
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                      child:  ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        child: ImageApi(
                          Url: data['foto_fasilitas'] ?? '',
                          defaultImage: "assets/images/default-card.jpg",
                          useBaseUrl: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Jenis Reservasi',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(data['jenis_reservasi'],
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Tujuan Penggunaan',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(data['deskripsi_reservasi'],
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Status Reservasi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    const Divider(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Status',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)
                          ),
                          Expanded(
                              child: Row(children: [Helper.badge(text: data['status'],type: statusColor)],)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Detail Status',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(
                                  data['detail_status'],
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    if(data['catatan_petugas'] != null) Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Text('Catatan Petugas',
                                  style: _primaryText,
                                  textAlign: TextAlign.left)),
                          Expanded(
                              child: Text(
                                  data['catatan_petugas'],
                                  style: _secondaryText,
                                  textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if(data['id_status_reservasi'] == '2') Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Helper.button(' Bukti Penerimaan ', callback: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => BuktiReservasi(idReservasi: idReservasi)));
                    })),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
            if(userdata['id_role'].toString() == '2') Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(data['id_status_reservasi'] != '3') Helper.button('Tolak', type: 'error', callback: (){_updateStatus(context, idReservasi, '3');}),
                  const SizedBox(width: 5,),
                  if(data['id_status_reservasi'] != '2') Helper.button('Setujui', callback: (){_updateStatus(context, idReservasi, '2');}),
                ],
              ),
            )
          ],
        ),
      );
    }
  }

  void _updateStatus(context, id_pengaduan, id_status) async {
    Map<String,dynamic> formData = {
      'id_reservasi' : id_pengaduan,
      'id_status_reservasi' : id_status,
      'type' : (id_status == '2') ? 'setujui' : 'tolak'
    };
    var data = await DataFetch.sendData(formData: formData, endpoint: 'reservasi', method: 'PATCH');

    Navigator.pop(context, true);
  }

}
