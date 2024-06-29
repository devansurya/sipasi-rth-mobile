
import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/helper/CustomTheme.dart';

import '../../helper/Helper.dart';
import '../component/ImageApi.dart';

class FormReservasi extends StatefulWidget {
  final String? idReservasi;
  final String? idRth;
  bool isLoaded =false;
  TextEditingController namaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nomorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController tujuanController = TextEditingController();
  String? _jenisReservasi;
  String? _fasilitas;
  bool _disableNama = false;
  bool _disableEmail = false;
  bool _disableNoTelp = false;
  Map<String, dynamic> formData = {};

  FormReservasi({super.key, this.idReservasi, this.idRth});

  @override
  createState() => _FormReservasiState();
}

class _FormReservasiState extends State<FormReservasi> {

  late Future<dynamic> _myFuture;
  String _title = 'Buat Reservasi';

  @override
  void initState() {
    widget.dateController.text = 'YYYY/MM/DD';
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
    final List<dynamic>? dataJenis = data['jenis']['data'] ?? {};
    final Map<String, dynamic> dataReservasi = data['reservasi'] ?? [];
    final List<dynamic>? dataFasilitas = data['fasilitas']['data'] ?? [];
    final Map<String, dynamic> dataRth = data['rth'] ?? [];
    final Map<String, dynamic> dataUser = data['user'] ?? [];

    widget.formData['id_user']  = dataUser['id_user'];
    widget.formData['id_rth']  = dataRth['id_rth'];
    widget.formData['id_reservasi']  = dataReservasi['id_reservasi'];

    //mandatory
    if(!widget.isLoaded) {

      widget.emailController.text = dataUser['email'];
      widget.namaController.text = dataUser['nama'];
      widget.nomorController.text = dataUser['no_telp'];

      if(widget.namaController.text.isNotEmpty) widget._disableNama = true;
      if(widget.emailController.text.isNotEmpty) widget._disableEmail = true;
      if(widget.nomorController.text.isNotEmpty) widget._disableNoTelp = true;



      if(dataReservasi['id_reservasi'] != null) {

        widget._jenisReservasi = dataReservasi['id_jenisreservasi'];
        widget._fasilitas = dataReservasi['id_fasilitas_reservasi'];
        widget.dateController.text = dataReservasi['tanggal_reservasi'];
        widget.tujuanController.text = dataReservasi['deskripsi_reservasi'];
      }
    }

    widget.isLoaded = true;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(_title, style: const TextStyle(color: CustomTheme.textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
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
        Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(children: [const FaIcon(FontAwesomeIcons.mapPin,size: 14,), Text(dataRth['alamat'])],),),
        _textRow(text: 'Nama pemesan',controller: widget.namaController, isReadOnly: widget._disableNama),
        _textRow(text: 'Email ',controller: widget.namaController, isReadOnly: widget._disableEmail),
        _textRow(text: 'No Telp ',controller: widget.nomorController, type: TextInputType.number, isReadOnly: widget._disableNoTelp),
        _dropdown(hint: 'Jenis reservasi', items: dataJenis, keyId: 'id_jenisreservasi',keyValue: 'jenis_reservasi', selectedValue: widget._jenisReservasi, callback: (data) {setState(() {
          widget._jenisReservasi = data;
        });}),
        _dropdown(hint: 'Pilih Fasilitas', items: dataFasilitas, keyId: 'id_fasilitas_reservasi',keyValue: 'nama', selectedValue: widget._fasilitas, callback: (data) {setState(() {
          widget._fasilitas = data;
        });}),

        _textRow(text: 'Tanggal Reservasi',controller: widget.dateController, type: TextInputType.datetime,isReadOnly: true ,callback: () {_showDate(context);}),
        _textRow(text: 'Detail Tujuan Reservasi',controller: widget.tujuanController, type: TextInputType.multiline, max: 5, min: 3),
        const SizedBox(height: 20,),
        Helper.button('Kirim', callback: (){_sendData(context);}),
        const SizedBox(height: 20,),
      ],
    );
  }


  void _sendData(BuildContext context) async {
    bool _checkData = _validateData();
    final String method = widget.idReservasi != null ? 'PATCH' : 'POST' ;

    if(_checkData) {
      if(widget.idReservasi != null) {
        widget.formData['id_reservasi'] = widget.idReservasi;
      }
      log(widget.formData.toString());
      Map<String,dynamic> response = await DataFetch.sendData(formData: widget.formData, endpoint: 'Reservasi', method: method);
      if(response['code'] == 200) {
        Navigator.pop(context, 'Saving Successful');
      }
    }
  }

  bool _validateData() {
    if(widget.namaController.text.isEmpty) {
      showToast('Kolom Nama wajib diisi.');
      return false;
    }
    widget.formData['nama'] = widget.namaController.text;
    if(widget.emailController.text.isEmpty){
      showToast('Kolom Email wajib diisi.');
      return false;
    }
    widget.formData['nama'] = widget.namaController.text;
    if(widget._jenisReservasi == null){
      showToast('Kolom jenis Reservasi wajib diisi.');
      return false;
    }
    widget.formData['id_jenisreservasi'] =widget._jenisReservasi;
    if(widget._fasilitas == null){
      showToast('Kolom Fasilitas wajib diisi.');
      return false;
    }
    widget.formData['id_fasilitas_reservasi'] = widget._fasilitas;
    if(widget.nomorController.text.isEmpty){
      showToast('Kolom Nomor wajib diisi.');
      return false;
    }
    if(widget.dateController.text == 'YYYY/MM/DD'){
      showToast('Kolom Tanggal Reservasi wajib diisi.');
      return false;
    }
    widget.formData['tanggal_reservasi'] = widget.dateController.text;
    if(widget.tujuanController.text.isEmpty){
      showToast('Kolom Tujuan Reservasi wajib diisi.');
      return false;
    }
    widget.formData['deskripsi_reservasi'] = widget.tujuanController.text;
    return true;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,);
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
  Widget _dropdown({required String hint, String? selectedValue, required List<dynamic>? items, required String keyId, required String keyValue, Function? callback}) {
    List<DropdownMenuItem<String>>? dropdowns = items?.map((e) {
      return DropdownMenuItem<String>(
        value: e[keyId],
        child: Text(e[keyValue],
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
            isExpanded: true,
            buttonStyleData: ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)),border:Border.all(color: CustomTheme.textPrimaryColor,width: 1) ),
              height: 40,
              width: 200,
            ),
            hint: Text(
              hint,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).hintColor,
              ),
            ),
            value: selectedValue,
            items: dropdowns,
            onChanged: (String? value) {
              if(callback != null) callback(value);
            },
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            )
        )),);
  }
  void _showDate(context) async{
    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime.now(), currentDate: DateTime.now(), lastDate: DateTime(2101));
    String formattedDate = 'YYYY/MM/DD';
    if(pickedDate != null) {
      formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
    setState(() {
      widget.dateController.text = formattedDate; //set foratted date to TextField value.
    });

  }
}
