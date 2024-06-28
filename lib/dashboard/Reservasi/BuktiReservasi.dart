import 'package:flutter/material.dart';

import '../../api/data.dart';
import '../../helper/CustomTheme.dart';
import '../../helper/Helper.dart';
import '../component/ImageApi.dart';

class BuktiReservasi extends StatelessWidget {
  final String idReservasi;

  const BuktiReservasi({super.key, required this.idReservasi});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DataFetch.get(
            endpoint: 'reservasi', param: 'id_reservasi=$idReservasi'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Helper.circleIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            Map<String, dynamic> data = snapshot.data['data'];

            return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: const Text('E-Ticket'),
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    Card(
                        surfaceTintColor: Colors.white,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            'E-Ticket Reservasi Ruang Terbuka Hijau',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  CustomTheme.textPrimaryColor,
                                            )))
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Text('Detail Reservasi',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: CustomTheme.textPrimaryColor,
                                          ))
                                    ],
                                  )),
                              _commonRow(field: 'Nama Lengkap', value: data['nama']),
                              _commonRow(field: 'Email', value: data['email']),
                              _commonRow(
                                  field: 'Tanggal Reservasi',
                                  value: Helper.formatDate(data['tanggal_reservasi'], fromFormat: 'yyyy-MM-dd')),
                              _commonRow(field: 'RTH', value: data['nama_rth']),
                              _commonRow(
                                  field: 'Fasilitas',
                                  value: data['nama_fasilitas'] ?? ''),
                              _commonRow(
                                  field: 'Kategori Reservasi',
                                  value: data['nama_fasilitas'] ?? ''),
                              _commonRow(
                                  field: 'Tujuan Penggunaan',
                                  value: data['nama_fasilitas'] ?? ''),
                              const SizedBox(height: 20),
                              ImageApi(
                                Url:
                                    '../qrcode/qrcode${data['id_reservasi']}.png',
                                useBaseUrl: true,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Tunjukan QR Code kepada petugas RTH',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: CustomTheme.textSecondaryColor),
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Divider(
                                height: 1,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: Center(
                                  child: Text(
                                      'Terima kasih telah menggunakan layanan reservasi kami. Selamat menikmati acara Anda di Ruang Terbuka Hijau!',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: CustomTheme.textPrimaryColor),
                                      textAlign: TextAlign.center),
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _commonRow({required String field, String? value}) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(
              '$field',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: CustomTheme.textPrimaryColor),
            )),
            Expanded(
                child: Text(
              value ?? '',
              style: const TextStyle(
                  fontSize: 14, color: CustomTheme.textPrimaryColor),
            ))
          ],
        ));
  }
}
