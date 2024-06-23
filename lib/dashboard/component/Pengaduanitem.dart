import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/pengaduan/DetailPengaduan.dart';
import 'package:sipasi_rth_mobile/dashboard/pengaduan/FormPengaduan.dart';
import 'package:sipasi_rth_mobile/helper/Helper.dart';

import '../../helper/CustomTheme.dart';

class PengaduanItem extends StatelessWidget {
  final String nama;
  final String id;
  final String jenis;
  final String status;
  final String tanggal;
  final String deskripsi;
  final String subject;
  final String statusType;
  final String statusId;
  final String rth;
  final String lokasi;
  final String visibilitas;
  final String statusPublish;

  const PengaduanItem({
    Key? key,
    required this.nama,
    required this.id,
    required this.jenis,
    required this.status,
    required this.tanggal,
    required this.deskripsi,
    required this.subject,
    required this.statusType,
    required this.statusId,
    required this.rth,
    required this.lokasi,
    required this.visibilitas,
    required this.statusPublish,
  });

  void _openDetails(BuildContext context, String idPengaduan) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPengaduan(idPengaduan: idPengaduan)));
  }

  void _openEdit(BuildContext context, String idPengaduan) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FormPengaduan(idPengaduan: idPengaduan)));
  }

  void _openDeleteConfirmation(BuildContext context, String idPengaduan) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool __isLoading = false;
        String __title = 'Konfirmasi Hapus';
        String __type = 'confirm';
        bool __showDeleteButton = true;
        bool __showCancelButton = true;
        bool __showCloseButton = false;
        return StatefulBuilder(
          builder: (context, setState) {
            __showCloseButton = false;

            Widget content = const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.circleExclamation,
                  color: Colors.red,
                  size: 50,
                ),
                Text('Hapus Pengaduan Ini?')
              ],
            );
            if (__isLoading) {
              content = const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [CircularProgressIndicator(), Text('Mohon Tunggu')],
              );
              __title = 'Mohon Tunggu';
              __showCancelButton = false;
              __showDeleteButton = false;
            }
            if (__type == 'success') {
              content = const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.circleCheck,
                    color: Colors.green,
                    size: 50,
                  ),
                  Text('Delete Berhasil')
                ],
              );
              __title = 'Mohon Tunggu';
              __showCancelButton = false;
              __showDeleteButton = false;
              __showCloseButton = true;
            }

            return AlertDialog(
              title: Text(__title),
              content: content,
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                        visible: __showCancelButton,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Helper.button('Batal', callback: () {
                            Navigator.of(context).pop();
                          }, type: 'info'),
                        )),
                    Visibility(
                        visible: __showCloseButton,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Helper.button('Ok', callback: () {
                            Navigator.of(context).pop();
                          }, type: 'info'),
                        )),
                    Visibility(
                        visible: __showDeleteButton,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Helper.button('Hapus !', callback: () async {
                            setState(() {
                              __isLoading = true;
                            });
                            var delete = await _delete(idPengaduan);
                            setState(() {
                              __isLoading = false;
                              __type = 'success';
                            });
                          }, type: 'error'),
                        )),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  _delete(String idPengaduan) async {
    var data = await DataFetch.delete(
        endpoint: 'Pengaduan', param: 'id_pengaduan=$idPengaduan');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              subject,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Text(
                    'Nama Pengadu: ',
                    style: TextStyle(
                        fontSize: 14,
                        color: CustomTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    nama,
                    style: const TextStyle(
                        fontSize: 14, color: CustomTheme.textPrimaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
                Helper.badge(text: status, type: statusType)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Text(
                    'Nama RTH: ',
                    style: TextStyle(
                        fontSize: 14,
                        color: CustomTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    rth,
                    style: const TextStyle(
                        fontSize: 14, color: CustomTheme.textPrimaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Text(
                    'Dibuat Pada : ',
                    style: TextStyle(
                        fontSize: 14,
                        color: CustomTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    Helper.formatDate(tanggal),
                    style: const TextStyle(
                        fontSize: 14, color: CustomTheme.textPrimaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Text(
                    'Jenis Pengaduan : ',
                    style: TextStyle(
                        fontSize: 14,
                        color: CustomTheme.textPrimaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    Helper.formatDate(tanggal),
                    style: const TextStyle(
                        fontSize: 14, color: CustomTheme.textPrimaryColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Deskripsi:',
              style: TextStyle(
                  fontSize: 14,
                  color: CustomTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              deskripsi,
              style: const TextStyle(
                  fontSize: 14, color: CustomTheme.textSecondaryColor),
            ),
            const Text(
              'Lokasi:',
              style: TextStyle(
                  fontSize: 14,
                  color: CustomTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              lokasi,
              style: const TextStyle(
                  fontSize: 14, color: CustomTheme.textSecondaryColor),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Helper.button("Detail ",
                        callback: () => _openDetails(context, id),
                        icon: FontAwesomeIcons.eye,
                        type: 'info')),
                if (statusId == '1')
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Helper.button("Edit ",
                          callback: () => _openEdit(context, id),
                          icon: FontAwesomeIcons.pencil,
                          type: 'info')),
                if (statusId == '1')
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Helper.button("Hapus ",
                          callback: () => _openDeleteConfirmation(context, id),
                          icon: FontAwesomeIcons.trash,
                          type: 'error')),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class PengaduanList extends StatelessWidget {
  final List<Widget> children;

  const PengaduanList({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Scaffold background color
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: children.length,
        itemBuilder: (context, index) {
          return children[index];
        },
      ),
    );
  }
}
