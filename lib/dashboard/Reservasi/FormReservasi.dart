
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
  TextEditingController dateController = TextEditingController();
  TextEditingController tujuanController = TextEditingController();
  FormReservasi({super.key, this.idReservasi, this.idRth});
  
  @override
  createState() => _FormReservasiState();
}

class _FormReservasiState extends State<FormReservasi> {

  late Future<dynamic> _myFuture;

  @override
  void initState() {
    super.initState();
    _myFuture = DataFetch.getDetailReservasi(idReservasi: widget.idReservasi,idRth: widget.idRth);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _myFuture, builder: (context, snapshot){
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
        Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Row(children: [FaIcon(FontAwesomeIcons.mapPin,size: 14,), Text(dataRth['alamat'])],),),
        _textRow(text: 'Nama pemesan',controller: widget.namaController),
        _textRow(text: 'Email ',controller: widget.namaController),
        _textRow(text: 'No Telp ',controller: widget.nomorController, type: TextInputType.number),
        _textRow(text: 'Tanggal Reservasi',controller: widget.dateController, type: TextInputType.datetime,isReadOnly: true ,callback: () {_showDate(context);}),
        _textRow(text: 'Deskripsi',controller: widget.tujuanController, type: TextInputType.multiline, max: 5, min: 3),
      ],
    );
  }

  Widget _textRow({required String text, bool isReadOnly = false, required TextEditingController controller, bool isRequired=true, TextInputType type = TextInputType.text, Function? callback, int max = 1, int min=1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(children: [
            Text(text, style: const TextStyle(color: CustomTheme.textPrimaryColor, fontWeight: FontWeight.bold),),
            if(isRequired) const Text('*', style: TextStyle(color: Colors.red))
          ]),
          TextField(controller: controller,readOnly: isReadOnly, decoration: InputDecoration(labelText: text),maxLines: max,minLines: min, keyboardType: type, onTap: () {
           if(callback != null) {
             callback();
           }
          })
        ],
      ),
    );
  }

  void _showDate(context) async{
    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime.now(), currentDate: DateTime.now(), lastDate: DateTime(2101));
    String formattedDate = 'yyyy-MM-dd';
    if(pickedDate != null) {
      formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
    setState(() {
      widget.dateController.text = formattedDate; //set foratted date to TextField value.
    });

  }
}
