
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:sipasi_rth_mobile/api/data.dart';
import 'package:sipasi_rth_mobile/dashboard/pengaduan/DetailPengaduan.dart';
import 'package:sipasi_rth_mobile/helper/CustomTheme.dart';

import '../dashboard/component/ImageApi.dart';
import '../dashboard/rth/Rth_detail.dart';
import '../helper/Helper.dart';
import 'login.dart';

class Home extends StatelessWidget {
  bool useAppbar = true;
  Home({super.key, this.useAppbar = true});

  PreferredSizeWidget ? getAppBar() {
    PreferredSizeWidget ? appbar;
    if(useAppbar) {
      appbar = PreferredSize(
        preferredSize: const Size.fromHeight(1000),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/icons/logo.png',height: 50),
                  const SizedBox(width: 8), // Add padding to the right side
                ],
              ),
            ),
          ),
        ),
      );
    }
    return appbar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:getAppBar(),
      backgroundColor: Colors.black12,
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: const HomeListElements(),
      ),
    );
  }
}
class HomeListElements extends StatefulWidget {
  const HomeListElements({super.key});

  @override
  createState() => _HomeList();
}

class _HomeList extends State<HomeListElements>{

  @override
  Widget build(BuildContext context) {
      return ListView(
        children: const <Widget>[
          InfoCard(),
          RthInfo(),
          RTHCarousel(),
          PengaduanCarousel(),
          PrivacyInfo(),
          FAQ()
        ],
      );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 0.5,
        child: Column(
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 0.7,
              child: Image.asset(
                'assets/images/illust-01.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Sistem Pemeliharaan dan Reservasi RTH.',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Sistem yang dapat memudahkan pengguna dalam menjaga kebersihan dan keamanan dari RTH (Ruang Terbuka Hijau), serta memanfaatkannya untuk kegiatan sosial atau rekreasi yang lebih terorganisir.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),);
  }
}
class RthInfo extends StatelessWidget {
  const RthInfo({super.key});

  Widget _getResult ({String? countRth, String? countPengaduan, String? countReservasi}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Jaga hijau kita!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),textAlign: TextAlign.left,),
          const Text('Reservasi mudah, Pengaduan cepat!', style: TextStyle(fontWeight: FontWeight.w300),textAlign: TextAlign.left,),
          Padding(
            padding: const EdgeInsets.only(top: 30,left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Column(
                  children: <Widget>[
                    const FaIcon(FontAwesomeIcons.tree, size: 30),
                    Text(countRth ?? '0'),
                    const Text('RTH')
                  ],
                )),
                Expanded(child: Column(
                  children: <Widget>[
                    const FaIcon(FontAwesomeIcons.triangleExclamation, size: 30),
                    Text(countPengaduan ?? '0'),
                    const Text('Pengaduan')
                  ],
                )),
                Expanded(child: Column(
                  children: <Widget>[
                    const FaIcon(FontAwesomeIcons.calendarCheck, size: 30),
                    Text(countReservasi ?? '0'),
                    const Text('Reservasi')
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataFetch.getPublicData(endpoint: 'summary'), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _getResult();
      } else if (snapshot.hasError) {
        return _getResult();
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return _getResult();
      }
      var data = snapshot.data['data'];
      var summary = data['count'] ?? {};
      return _getResult(countRth:summary['rth'].toString(),countPengaduan: summary['pengaduan'].toString(),countReservasi: summary['reservasi'].toString());
    });
  }
}
class PrivacyInfo extends StatelessWidget {
  const PrivacyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(238, 246, 241, 1)),
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              // alignment: ,
              child: Image.asset(
                'assets/images/illust-02.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('AMAN TIDAK YA?', style: TextStyle(color: CustomTheme.textActiveColor)),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Sistem Menjaga Privasi dan Keamanan Pengguna.',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5, left: 10, right: 10),
            child: ExpansionTileCard(
              title: Text('Publik',style: TextStyle(fontWeight: FontWeight.bold)),
              elevation: 0.0,
              baseColor: Color.fromRGBO(238, 246, 241, 1),
              expandedColor: Color.fromRGBO(238, 246, 241, 1),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Pengaduan dengan visibilitas publik akan ditampilkan pada Portal SIPASI RTH dan dapat dilihat oleh siapapun beserta informasi pembuat.'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5, left: 10, right: 10,),
            child: ExpansionTileCard(
              title: Text('Anonim',style: TextStyle(fontWeight: FontWeight.bold),),
              elevation: 0.0,
              baseColor: Color.fromRGBO(238, 246, 241, 1),
              expandedColor: Color.fromRGBO(238, 246, 241, 1),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Pengaduan dengan visibilitas anonim tetap ditampilkan pada Portal SIPASI RTH dan dapat dilihat oleh siapapun, namun informasi pembuat akan di sembunyikan.'),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5, left: 10, right: 10,bottom: 10),
            child: ExpansionTileCard(
              title: Text('Private',style: TextStyle(fontWeight: FontWeight.bold)),
              elevation: 0.0,
              baseColor: Color.fromRGBO(238, 246, 241, 1),
              expandedColor: Color.fromRGBO(238, 246, 241, 1),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Pengaduan dengan visibilitas private akan disembunyikan dari Portal SIPASI RTH, namun tetap masuk ke dalam sistem.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}
class FAQ extends StatelessWidget {
  const FAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('FAQ', style: TextStyle(color: CustomTheme.textActiveColor)),
            Text(
              'Tidak Menemukan Jawaban?',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Jika kamu tidak menemukan jawaban dari pertanyaanmu, kamu dapat mengirim pertanyaan ke email kami yang tertera pada menu kontak.'),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: ExpansionTileCard(
                title: Text('Bagaimana cara membuat pengaduan?',style: TextStyle(fontWeight: FontWeight.bold)),
                elevation: 4.0,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                        'Kamu bisa melakukan pengaduan lewat portal sipasi di dalam halaman detail RTH atau kamu bisa login dengan akun sipasi, lalu masuk ke dalam aplikasi pengaduanku, disana kamu dapat melihat menu untuk membuat pengaduanmu.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: ExpansionTileCard(
                title: Text('Apakah privasi pengguna terjaga?',style: TextStyle(fontWeight: FontWeight.bold)),
                elevation: 4.0,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Sangat amat terjaga, kami menyediakan jenis privasi yang akan menjaga identitas dari pelapor mungkin untuk konten pengaduan yang lumayan sensitif.'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: ExpansionTileCard(
                title: Text('Bagaimana cara mereservasi RTH?',style: TextStyle(fontWeight: FontWeight.bold),),
                elevation: 4.0,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Kamu bisa melakukan reservasi RTH pada portal SIPASI RTH dengan cara masuk ke halaman detail RTH dan klik tombol reservasi, disana kamu harus mengisi beberapa informasi untuk melakukan reservasi.'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: ExpansionTileCard(
                title: Text('Bagaimana cara tracking proses reservasi yang sudah di ajukan?',style: TextStyle(fontWeight: FontWeight.bold),),
                elevation: 4.0,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Kamu bisa masuk ke dalam aplikasi pengelola atau admin SIPASI RTH dan melihat status serta bukti reservasi kamu disana.'),
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

}
class RTHCarousel extends StatelessWidget {
  const RTHCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataFetch.getPublicData(endpoint: 'rth'), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Helper.circleIndicator();
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No data available'));
      }
      else {
        var data = snapshot.data['data'];
        if(data == 'relog') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginView()));
        }

        final parsedData = List<Map<dynamic, dynamic>>.from(data);
        final widget = getCard(parsedData, context);
        return Container(
          color: const Color.fromRGBO(238, 246, 241, 1),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Ruang terbuka Hijau', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),textAlign: TextAlign.left,),
              ),
              FlutterCarousel(items: widget, options: CarouselOptions(autoPlay: true,height: 430,enableInfiniteScroll: true)),
            ],
          ),
        );
      }
    });
  }

  List<Widget> getCard(List<Map> data, BuildContext context) {
    List<Column> rows = [];

    for (var element in data) {
      Card card = Card(
        elevation: 4.0,
        key: ValueKey<String>(element['id_rth']),
        surfaceTintColor: Colors.white,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(8.0), // Added margin for better spacing
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
              child: ImageApi(
                Url: element['foto_rth'],
                defaultImage: "assets/images/default-card.jpg",
                useBaseUrl: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjusted padding
              child: GestureDetector(
                onTap: () {
                  final String key = element['id_rth'];
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RthDetail(idRth: key,)));
                },
                child: Text(
                  element['nama_rth'],
                  style: const TextStyle(
                    fontSize: 18.0, // Increased font size for the title
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.textPrimaryColor, // Improved color for better readability
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // Ensure the title stays on one line
                  semanticsLabel: 'Title', // Accessibility label
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjusted padding
              child: Text(
                element['deskripsi_rth'],
                style: const TextStyle(
                  fontSize: 14.0, // Slightly smaller font size for the description
                  color: CustomTheme.textPrimaryColor, // Use a lighter color for the description
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                semanticsLabel: 'Description', // Accessibility label
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      final String key = element['id_rth'];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RthDetail(idRth: key,)));
                    },
                    child: const Text(
                      'Selengkapnya..',
                      style: TextStyle(color: CustomTheme.textActiveColor), // Button text color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      Column column = Column(
        children: [
          Padding(padding: const EdgeInsets.all(0.0),child: card),
        ],
      );

      rows.add(column);
    }
    return rows;
  }


}
class PengaduanCarousel extends StatelessWidget {
  const PengaduanCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: DataFetch.getPublicData(endpoint: 'pengaduan'), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Helper.circleIndicator();
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No data available'));
      }
      else {
        var data = snapshot.data['data'];
        if(data == 'relog') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginView()));
        }

        final parsedData = List<Map<dynamic, dynamic>>.from(data);
        final widget = getCard(parsedData, context);
        return Container(
          color: const Color.fromRGBO(238, 246, 241, 1),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Pengaduan Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),textAlign: TextAlign.left,),
              ),
              FlutterCarousel(items: widget, options: CarouselOptions(autoPlay: true,height: 500,enableInfiniteScroll: true)),
            ],
          ),
        );
      }
    });
  }

  List<Widget> getCard(List data, BuildContext context) {
    List<Column> rows = [];

    for (var element in data) {

      Card card = Card(
        elevation: 4.0,
        key: ValueKey<String>(element['id_pengaduan']),
        surfaceTintColor: Colors.white,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(8.0), // Added margin for better spacing
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
              child: ImageApi(
                Url: element['foto'],
                defaultImage: "assets/images/default-card.jpg",
                useBaseUrl: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjusted padding
              child: Text(
                "- ${element['jenis_pengaduan']}",
                style: const TextStyle(
                  fontSize: 15.0, // Increased font size for the title
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.textActiveColor, // Improved color for better readability
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1, // Ensure the title stays on one line
                semanticsLabel: 'Title', // Accessibility label
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjusted padding
              child: GestureDetector(
                onTap: () {
                  final String key = element['id_pengaduan'];
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPengaduan(idPengaduan: key)));
                },
                child: Text(
                  element['subjek'],
                  style: const TextStyle(
                    fontSize: 18.0, // Increased font size for the title
                    fontWeight: FontWeight.bold,
                    color: CustomTheme.textPrimaryColor, // Improved color for better readability
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // Ensure the title stays on one line
                  semanticsLabel: 'Title', // Accessibility label
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjusted padding
              child: Text(
                element['deskripsi_pengaduan'],
                style: const TextStyle(
                  fontSize: 14.0, // Slightly smaller font size for the description
                  color: CustomTheme.textPrimaryColor, // Use a lighter color for the description
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                semanticsLabel: 'Description', // Accessibility label
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjusted padding
              child:  Row(

                children: [
                  const FaIcon(FontAwesomeIcons.calendar,size: 14,),
                  const SizedBox(width: 5,),
                  Text(
                    Helper.formatDate(element['create_date']),
                    style: const TextStyle(
                      fontSize: 14.0, // Slightly smaller font size for the description
                      color: CustomTheme.textPrimaryColor, // Use a lighter color for the description
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    semanticsLabel: 'Date', // Accessibility label
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      final String key = element['id_pengaduan'];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPengaduan(idPengaduan: key)));
                    },
                    child: const Text(
                      'Selengkapnya..',
                      style: TextStyle(color: CustomTheme.textActiveColor), // Button text color
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

      Column column = Column(
        children: [
          Padding(padding: const EdgeInsets.all(0.0),child: card),
        ],
      );

      rows.add(column);
    }
    return rows;
  }
}