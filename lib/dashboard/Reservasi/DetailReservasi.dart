import 'package:flutter/material.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/helper/CustomTheme.dart';

import '../../helper/Helper.dart';

class DetailReservasi extends StatelessWidget {
  final String idReservasi;
  final TextStyle _secondaryText = const TextStyle(fontSize: 14,color: CustomTheme.textPrimaryColor);
  final TextStyle _primaryText = const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: CustomTheme.textPrimaryColor);

  DetailReservasi({super.key, required this.idReservasi});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataFetch.get(
        endpoint: 'reservasi',
        param: 'id_reservasi=$idReservasi'
      ),
      builder: (context, snapshot) => _builder(context, snapshot));
  }

  Widget _builder(context, snapshot){
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Helper.circleIndicator();
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No data available'));
    }
    else {
      Map<String, dynamic> data = snapshot.data['data'];
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Detail Reservasi'),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
          surfaceTintColor: Colors.white,
          color: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Informasi Pemesan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.textPrimaryColor,
                  ),
                ),
              ),
              const Divider(),
              ///Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Nama Lengkap', style: _primaryText, textAlign: TextAlign.left)),
                    Expanded(child: Text('Devan', style: _secondaryText, textAlign: TextAlign.left)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Email', style: _primaryText, textAlign: TextAlign.left)),
                    Expanded(child: Text('devan@gmail.com', style: _secondaryText, textAlign: TextAlign.left)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Nomor Telepon', style: _primaryText, textAlign: TextAlign.left)),
                    Expanded(child: Text('123-456-7890', style: _secondaryText, textAlign: TextAlign.left)),
                  ],
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Status Reservasi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    const Divider(),
                    ///Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('Status', style: _primaryText, textAlign: TextAlign.left)),
                          Expanded(child: Text('Disetujui', style: _secondaryText, textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('Detail Status', style: _primaryText, textAlign: TextAlign.left)),
                          Expanded(child: Text('Reservasi telah di setujui oleh petugas RTH', style: _secondaryText, textAlign: TextAlign.left)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

}
