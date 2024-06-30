import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/component/ReservasiItem.dart';

import '../../app_state.dart';
import '../../helper/CustomTheme.dart';
import '../../helper/Helper.dart';
import '../../public/login.dart';

class Reservasi extends StatefulWidget {
  @override
  createState() => _ReservasiState();
}

class _ReservasiState  extends State<Reservasi> {

  late Future<dynamic> _myFuture;
  late Future<dynamic> _statusFutures;
  late Future<dynamic> _jenisFutures;
  Map<String, bool> _statusValue ={};
  Map<String, bool> _jenisValue ={};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myFuture = DataFetch.get(endpoint: 'Reservasi');
    _statusFutures = DataFetch.getPublicData(endpoint: 'Status_reservasi');
    _jenisFutures = DataFetch.getPublicData(endpoint: 'Jenis_reservasi');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setFilterCallback(() {
        _showFilter(context);
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginView()));
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
    String jenisFilter = '';
    String statusFilter = '';

    _jenisValue.forEach((key, value) {
      if(value) {
        jenisFilter +='$key,';
      }
    });
    if(jenisFilter.isNotEmpty) {
      if (jenisFilter.endsWith(',')) {
        jenisFilter = jenisFilter.substring(0, jenisFilter.length - 1);
      }
      jenisFilter = 'id_jenis=${jenisFilter}';
    }

    _statusValue.forEach((key, value) {
      if(value) {
        statusFilter +='$key,';
      }
    });
    if(statusFilter.isNotEmpty) {
      if (statusFilter.endsWith(',')) {
        statusFilter = statusFilter.substring(0, statusFilter.length - 1);
      }
      String and = '';
      if(jenisFilter.isNotEmpty) and = '&';
      statusFilter = '${and}id_status=${statusFilter}';
    }
    String filter = '$jenisFilter$statusFilter';

    setState(() {
      _myFuture = DataFetch.get(endpoint: 'Reservasi',param: filter);
    });
  }

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height, // Adjust height as needed
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Status Reservasi',
                                style: TextStyle(
                                  color: CustomTheme.textPrimaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          _filterWidget(
                              future: _statusFutures,
                              key: 'id_status_reservasi',
                              setState: setState,
                              name: 'status',
                              valueHolder: _statusValue
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Jenis Reservasi',
                                style: TextStyle(
                                  color: CustomTheme.textPrimaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          _filterWidget(
                              future: _jenisFutures,
                              key: 'id_jenisreservasi',
                              setState: setState,
                              name: 'jenis_reservasi',
                              valueHolder: _jenisValue
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Helper.button(
                            'Filter',
                            callback: () {
                              _updateData();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _filterWidget({required Future<dynamic> future, required String key, required StateSetter setState,required String name, required Map<String, bool> valueHolder}) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Helper.circleIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final result = snapshot.data['data'];
          final dataList = List<Map<String, dynamic>>.from(result);
          List<Widget> itemList = [];

          for (Map<String, dynamic> data in dataList) {

            if (valueHolder[data[key].toString()] == null) {
              valueHolder[data[key].toString()] = true;
            }

            Widget item = GestureDetector(
              onTap: () {
                setState(() {
                  bool vals = valueHolder[data[key].toString()] ?? false;
                  valueHolder[data[key].toString()] = vals ? false : true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: valueHolder[data[key].toString()],
                        onChanged: (value) {
                          setState(() {
                            valueHolder[data[key].toString()] = value ?? true;
                          });
                        },
                      ),
                      Text(
                        data[name].toString(),
                        style: const TextStyle(
                          color: CustomTheme.textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
            itemList.add(item);
          }

          return Column(children: itemList);
        }
      },
    );
  }
}