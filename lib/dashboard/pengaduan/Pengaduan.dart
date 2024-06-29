import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/component/Pengaduanitem.dart';

import '../../app_state.dart';
import '../../helper/CustomTheme.dart';
import '../../helper/Helper.dart';
import '../../public/login.dart';

class Pengaduan extends StatefulWidget {
  const Pengaduan({super.key});

  @override
  createState() => _PengaduanState();
}

class _PengaduanState extends State<Pengaduan> {
  bool _isMypengaduan = false; ///filter only pengaduan made by current user
  bool _isMyRthPengaduan = false; ///filter only pengaduan made by current user
  List<Map<String, bool>> _kategoriFilters = []; ///hold filtered kategori
  List<Map<String, bool>> _status = []; ///hold filtered status pengaduan
  Map<String, bool> _jenisvalue ={};
  Map<String, bool> _statusvalue ={};
  late Future<dynamic> _futures;
  late Future<dynamic> _statusfutures;
  late Future<dynamic> _jenisfutures;

  @override
  void initState() {
    super.initState();
    _futures = DataFetch.get(endpoint: 'Pengaduan');
    _statusfutures = DataFetch.getPublicData(endpoint: 'Status_pengaduan');
    _jenisfutures = DataFetch.getPublicData(endpoint: 'Jenis_pengaduan');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setFilterCallback(() {
        _showFilter(context);
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futures,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Helper.circleIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          if(snapshot.data == 'relog') {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
          }
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
                                'Status',
                                style: TextStyle(
                                  color: CustomTheme.textPrimaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          _filterWidget(
                            future: _statusfutures,
                            key: 'id_status',
                            setState: setState,
                            name: 'status',
                            valueHolder: _statusvalue
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Kategori ',
                                style: TextStyle(
                                  color: CustomTheme.textPrimaryColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          _filterWidget(
                            future: _jenisfutures,
                            valueHolder: _jenisvalue,
                            key: 'id_jenispengaduan',
                            setState: setState,
                            name: 'jenis_pengaduan',
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
                              // Implement your filter logic here
                              _getData();
                              Navigator.pop(context); // Close the bottom sheet
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

  void _getData() {
    String jenisFilter = '';
    String statusFilter = '';

    _jenisvalue.forEach((key, value) {
      if(value) {
        jenisFilter +='$key,';
      }
    });
    if(jenisFilter.isNotEmpty) {
      if (jenisFilter.endsWith(',')) {
        jenisFilter = jenisFilter.substring(0, jenisFilter.length - 1);
      }
      jenisFilter = 'id_jenispengaduan=${jenisFilter}';
    }

    _statusvalue.forEach((key, value) {
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
    String filter = '?$jenisFilter$statusFilter';

    log(filter);

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
