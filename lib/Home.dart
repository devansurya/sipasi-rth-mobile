
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

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


  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Jaga hijau kita!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),textAlign: TextAlign.left,),
          Text('Reservasi mudah, Pengaduan cepat!', style: TextStyle(fontWeight: FontWeight.w300),textAlign: TextAlign.left,),
          Padding(
            padding: EdgeInsets.only(top: 30,left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Column(
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.house, size: 30),
                    Text('10'),
                    Text('RTH')
                  ],
                )),
                Expanded(child: Column(
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.addressCard, size: 30),
                    Text('10'),
                    Text('Pengaduan')
                  ],
                )),
                Expanded(child: Column(
                  children: <Widget>[
                    FaIcon(FontAwesomeIcons.addressCard, size: 30),
                    Text('20'),
                    Text('Reservasi')
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
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
            child: Text('AMAN TIDAK YA?', style: TextStyle(color: Colors.green)),
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
            Text('FAQ', style: TextStyle(color: Colors.green)),
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