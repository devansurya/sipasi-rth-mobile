import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sipasi_rth_mobile/dashboard/Reservasi/DetailReservasi.dart';
import 'package:sipasi_rth_mobile/dashboard/Reservasi/FormReservasi.dart';

import '../../helper/CustomTheme.dart';
import '../../helper/Helper.dart';

class ReservasiItem extends StatelessWidget {
  final String nama;
  final String id;
  final String idRth;
  final String namaRth;
  final String jenis;
  final String status;
  final String tanggal;
  final String tanggalReservasi;
  final String deskripsi;
  final String idStatusReservasi;
  final String statusBadgeColor;
  final bool showEditButton;
  final Function successCallback;

  ReservasiItem({
    super.key,
    required this.showEditButton,
    required this.idRth,
    required this.nama,
    required this.id,
    required this.jenis,
    required this.status,
    required this.tanggal,
    required this.deskripsi,
    required this.namaRth,
    required this.idStatusReservasi,
    required this.statusBadgeColor,
    required this.tanggalReservasi,
    required this.successCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Nama:', nama, context),
            _buildInfoRow('Nama RTH:', namaRth, context),
            _buildInfoRow('Dibuat Pada:', Helper.formatDate(tanggal), context),
            _buildInfoRow('Tanggal Reservasi:', Helper.formatDate(tanggalReservasi, fromFormat: 'yyyy-MM-dd'), context),
            _buildInfoRow('Jenis Reservasi:', jenis, context),
            const Divider(),
            const Text(
              'Tujuan Reservasi :',
              style: TextStyle(
                fontSize: 14,
                color: CustomTheme.textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              deskripsi,
              style: const TextStyle(
                fontSize: 14,
                color: CustomTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if(idStatusReservasi == '1' && showEditButton) Helper.button(
                  "Edit ",
                  callback: () => _openEdit(context, id),
                  icon: FontAwesomeIcons.pencil,
                  type: 'info',
                ),
                SizedBox(width: 5),
                Helper.button(
                  "Detail ",
                  callback: () => _openDetails(context, id),
                  icon: FontAwesomeIcons.eye,
                  type: 'info',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: CustomTheme.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: CustomTheme.textPrimaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (label == 'Nama:') ...[
            const SizedBox(width: 10),
            Helper.badge(text: status, type: statusBadgeColor),
          ],
        ],
      ),
    );
  }

  _openDetails(BuildContext context, String id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailReservasi(idReservasi: id)));
  }

  _openEdit(BuildContext context, String id)  async{
    var data = await Navigator.push(context, MaterialPageRoute(builder: (context) => FormReservasi(idReservasi: id)));
    log(data.toString());
    if(data == 'Saving Successful') {
      Helper.showSuccessSnackbar(context, 'Update Berhasil');
      successCallback();
    }
  }

}
