import 'package:flutter/material.dart';
import 'package:sipasi_rth_mobile/dashboard/component/pengaduanitem.dart';

class Pengaduan extends StatelessWidget {
  const Pengaduan({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PengaduanItem> reports = [
      PengaduanItem(
        description: 'Flood in the main street',
        date: DateTime.now().subtract(const Duration(days: 1)),
        severity: 'High',
      ),
      PengaduanItem(
        description: 'Tree fallen near park',
        date: DateTime.now().subtract(const Duration(days: 2)),
        severity: 'Medium',
      ),
      PengaduanItem(
        description: 'Pothole in the road',
        date: DateTime.now().subtract(const Duration(days: 3)),
        severity: 'Low',
      ),
    ];

    return PengaduanItemList(reports: reports);
  }
}