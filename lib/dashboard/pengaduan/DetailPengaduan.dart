import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/component/ImageApi.dart';
import 'package:sipasi_rth_mobile/helper/Helper.dart';

import '../../app_state.dart';
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
  late Future<dynamic> _statusFuture;
  late Future<dynamic> _future;
  String _selectedStatus = '';
  String _selectedPublish = '';
  Map<String, dynamic> formdata ={};

  @override
  initState(){
    super.initState();
    _statusFuture = DataFetch.getPublicData(endpoint: 'Status_pengaduan');
    _future = DataFetch.get(endpoint: 'pengaduan',param: 'id_pengaduan=${widget.idPengaduan}' );
  }
  builder(context, snapshot, appState) {
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

      final Map<String, dynamic> userdata = appState.userData;
      final bool showAddAction = userdata['list_id_rth'] != null && userdata['list_id_rth'].contains(data['id_rth']);

      _selectedStatus = (_selectedStatus.isEmpty) ? result['id_status_pengaduan'] : _selectedStatus;
      _selectedPublish = (_selectedPublish.isEmpty) ? result['status_publish'] : _selectedPublish;
      formdata['id_pengaduan'] = data['id_pengaduan'];

      return Scaffold(
        appBar: AppBar(surfaceTintColor: Colors.white,title: const Text('Detail Pengaduan'),),
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
                padding: const EdgeInsets.symmetric(vertical: 10),
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
                padding: const EdgeInsets.symmetric(vertical: 10),
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
              Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(
                children: [
                  const Text(
                    'status publish : ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Helper.badge(text: data['status_publish'] == '1' ? 'published' : 'belum di publish', type: data['status_publish'] == '1' ? 'success' : 'info'),],),),
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
              const SizedBox(height: 16.0),
              if(showAddAction)
                const Divider(),
              if(showAddAction)
                _dropdownActions(name: 'Status Pengaduan', future: _statusFuture, hint: 'Status',keyId: 'id_status',keyValue: 'status',callback: (value){
                  setState(() {
                    _selectedStatus =value;
                  });
                },selectedValue: _selectedStatus),
              if(showAddAction)
                _dropdownActions2(name: 'Status Publish',callback: (value) {
                  setState(() {
                    _selectedPublish = value;
                  });
                },selectedValue: _selectedPublish),
              if(showAddAction)
                Helper.button('Simpan', callback: (){
                  _sendData(context);
                }),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final AppState appState = Provider.of<AppState>(context, listen: false);

    return FutureBuilder(future: _future, builder: (context, snapshot) => builder(context, snapshot,appState));
  }

  Widget _dropdownActions({required String name, required Future future , required String hint, required String keyId, required String keyValue, Function? callback, String? selectedValue}) {
    return FutureBuilder(future: future ?? _statusFuture, builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Helper.circleIndicator();
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data.isEmpty) {
        return const Center(child: Text('No data available'));
      } else {

        final result = snapshot.data['data'];
        final data = List<dynamic>.from(result);

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize:16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(children: [Expanded(child: _dropdown(hint:name, items: data,keyId:keyId,keyValue:keyValue,callback: callback,selectedValue: selectedValue))],)
          ],
        );
      }
    });
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

  Widget _dropdownActions2({required String name, Function? callback, String? selectedValue}) {
    List<dynamic> data = [
      {
        'name': 'Publish',
        'id': '1',
      },
      {
        'name': 'Non Publish',
        'id': '0',
      }
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize:16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(children: [Expanded(child: _dropdown(hint:name, items: data,keyId:'id',keyValue:'name',callback: callback,selectedValue: selectedValue))],)
      ],
    );
  }

  void _sendData(context) async{


    if(_selectedPublish != null) {
      formdata['status_publish'] = "$_selectedPublish";
    }
    if(_selectedStatus != null) {
      formdata['id_status_pengaduan'] = _selectedStatus;
    }

    var data = await DataFetch.sendData(formData: formdata, endpoint: 'Pengaduan', method: 'PATCH');
    Navigator.pop(context, true);

  }
}

