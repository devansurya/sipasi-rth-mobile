
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/helper/CustomTheme.dart';

import '../../helper/Helper.dart';
import '../component/ImageApi.dart';

class FormReservasi extends StatefulWidget {
  final String? idReservasi;
  final String? idRth;
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nomorController = TextEditingController();
  TextEditingController tujuanController = TextEditingController();

  FormReservasi({super.key, this.idReservasi, this.idRth});
  
  @override
  createState() => _FormReservasiState();
}

class _FormReservasiState extends State<FormReservasi> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataFetch.getDetailReservasi(idReservasi: widget.idReservasi,idRth: widget.idRth), builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Helper.circleIndicator();
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No data available'));
      } else {
        Map<String, dynamic> data = snapshot.data ?? {};
        log(data.toString());
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: const Text('Form Reservasi'),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(
              elevation: 4,
              surfaceTintColor: Colors.white,
              color: Colors.white,
              child: _view(data),
            ),
          ),
        );
      }
    });
  }

  Widget _view(data) {
    final List<dynamic> dataStatus = data['status']['data']  ?? [];
    final List<dynamic> dataJenis = data['jenis']['data'] ?? {};
    final Map<String, dynamic> dataReservasi = data['reservasi'] ?? [];
    final Map<String, dynamic> dataRth = data['rth'] ?? [];



    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              const Text('Buat Reservasi', style: TextStyle(color: CustomTheme.textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
              Text(dataRth['nama_rth'], style: const TextStyle(color: CustomTheme.textActiveColor, fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: ImageApi(
            Url: dataRth['foto_rth'],
            defaultImage: "assets/images/default-card.jpg",
            useBaseUrl: true,
          ),
        ),
        _textRow(text: 'Nama pemesan',controller: widget.namaController)
      ],
    );
  }

  Widget _textRow({required String text, bool isReadOnly = false, required TextEditingController controller, bool isRequired=true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(children: [
            Text(text, style: const TextStyle(color: CustomTheme.textPrimaryColor, fontWeight: FontWeight.bold)),
            if(isRequired) const Text('*', style: TextStyle(color: Colors.red))
          ]),
          TextField(controller: controller,readOnly: isReadOnly, decoration: InputDecoration(labelText: text),)
        ],
      ),
    );
  }

}
