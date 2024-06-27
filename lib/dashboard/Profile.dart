import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/helper/CustomTheme.dart';

import '../helper/Helper.dart';
import '../public/login.dart';

class Profile extends StatelessWidget {

  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataFetch.getUser(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Helper.circleIndicator();
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No data available'));
      }
      else {
        if (snapshot.data == 'relog') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginView()));
        }
        Map data = snapshot.data['data'];

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(
                        'assets/images/default-avatar.jpg'),
                  ),
                ),
                Text(
                  data['nama'],
                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: CustomTheme.textPrimaryColor),
                ),
                _commonRow(value:Helper.formatDate(data['create_date']),icon: FontAwesomeIcons.calendar, name: 'Sejak '),
                _commonRow(value:data['email'],icon: FontAwesomeIcons.at,name: 'Email'),
                _commonRow(value:data['no_telp'],icon: FontAwesomeIcons.phone, name: 'Telp'),
                _commonRow(value:data['kelurahan'],icon: FontAwesomeIcons.city, name: 'Kelurahan'),
                _commonRow(value:data['kecamatan'],icon: FontAwesomeIcons.city, name: 'kecamatan'),
                _commonRow(value:data['alamat'],icon: FontAwesomeIcons.addressBook, name: 'alamat'),
                _commonRow(value:data['role'],icon: FontAwesomeIcons.addressBook, name: 'Role'),
              ],
            ),
          ),
        );
      }
    });
  }


  Widget _commonRow({required IconData icon, required String value, required String name}) {

    return Column(
        children: [
          const SizedBox(height: 5),
          Row(children: <Widget>[
            FaIcon(icon, size: 16,),
            const SizedBox(width: 10),
            Text(
              '$name : ',
              style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: CustomTheme.textPrimaryColor),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: CustomTheme.textPrimaryColor),
            )),
        ])
        ]);
  }
}