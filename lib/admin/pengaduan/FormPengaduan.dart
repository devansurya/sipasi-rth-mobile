import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/data.dart';
import 'package:file_picker/file_picker.dart';

import '../../helper/CustomTheme.dart';

class FormPengaduan extends StatefulWidget {
  final String type;
  final int? id;
  final int? idPengaduan;

  const FormPengaduan({super.key, this.type = 'New', this.id, this.idPengaduan});


  @override
  _FormPengaduanState createState() => _FormPengaduanState();
}

class _FormPengaduanState extends State<FormPengaduan> {
  late Map<String, dynamic> formdata;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
  Widget _prevImage = Image.asset('assets/images/default-card.jpg');
  bool _isPrevImageVisible = false;
  File? _file = null;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    formdata = {
      'id_rth': widget.id,
      'id_pengaduan': widget.idPengaduan,
    };
  }

  //update formdata
  void updateFormData(String key, dynamic value) {
    setState(() {
      formdata[key] = value;
    });
  }

  void sendData(BuildContext context) async {
      if(validateForm()) {
        var response = await DataFetch.sendData(endpoint: 'Pengaduan',formData: formdata,file: _file);
        if(response != null) {
          Navigator.pop(context, response);
        }
      }
  }

  bool validateForm() {
    if(nameController.text.isEmpty) {
      showToast('Kolom Nama wajib diisi.');
      return false;
    }
    if(emailController.text.isEmpty) {
      showToast('Kolom Email wajib diisi.');
      return false;
    }
    if(!emailController.text.contains('@')){
      showToast('Harap masukkan alamat Email yang valid.');
      return false;
    }
    if(formdata['visibilitas']== null){
      showToast('Harap Pilih Privasi');
      return false;
    }
    if(formdata['jenis_pengaduan']== null){
      showToast('Harap Pilih Jenis Pengaduan');
      return false;
    }
    if(judulController.text.isEmpty){
      showToast('Kolom Judul wajib diisi.');
      return false;
    }
    if(deskripsiController.text.isEmpty){
      showToast('Kolom Deskripsi wajib diisi.');
      return false;
    }
    if(lokasiController.text.isEmpty){
      showToast('Kolom Lokasi wajib diisi.');
      return false;
    }

    formdata['nama'] =  nameController.text;
    formdata['email'] =  emailController.text;
    formdata['subjek'] =  judulController.text;
    formdata['deskripsi'] =  deskripsiController.text;
    formdata['lokasi'] =  lokasiController.text;
    formdata['jenis'] = formdata['jenis_pengaduan'];

    return true;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,);
  }

  void _uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if(result != null) {
      PlatformFile file = result.files.first;
      String path = file.path ?? '';
      File imageFile = File(path.replaceFirst('file://', ''));
      setState(() {
        _file = imageFile;
        _prevImage = Image.file(imageFile);
        _isPrevImageVisible = true;
      });
    }
  }
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      String path = pickedFile.path ?? '';
      File imageFile = File(path);
      setState(() {
        _file = imageFile;
        _prevImage = Image.file(imageFile);
        _isPrevImageVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DataFetch.getBaseUrl(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Form Pengaduan'), // Updated title
            ),
            body: ListView(
              padding: const EdgeInsets.only(left: 10,right: 10),
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            CustomTheme.primaryText('Nama'),
                            const Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        TextField(controller: nameController),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            CustomTheme.primaryText('Email'),
                            const Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        TextField(controller: emailController),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            CustomTheme.primaryText('Privasi'),
                            const Text('*', style: TextStyle(color: Colors.red),),
                          ],
                        ),
                        DropdownData(onChanged: (value) => updateFormData('visibilitas', value)),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            CustomTheme.primaryText('Jenis Pengaduan'),
                            const Text('*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        DropdownData(onChanged: (value) => updateFormData('jenis_pengaduan', value),endpoint: 'jenis_pengaduan',),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            CustomTheme.primaryText('Judul'),
                            const Text('*', style: TextStyle(color: Colors.red),),
                          ],
                        ),
                        TextField(controller: judulController),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            CustomTheme.primaryText('Deskripsi'),
                            const Text('*', style: TextStyle(color: Colors.red),),
                          ],
                        ),
                        TextField(controller: deskripsiController, keyboardType: TextInputType.multiline, minLines: 3, maxLines: 5),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            CustomTheme.primaryText('Detail Lokasi'),
                            const Text('*', style: TextStyle(color: Colors.red),),
                          ],
                        ),
                        TextField(controller: lokasiController, keyboardType: TextInputType.multiline, minLines: 3, maxLines: 5),
                      ],
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomTheme.primaryText('Lampiran'),
                        Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            direction: Axis.horizontal,
                            children: [
                              ElevatedButton(
                                onPressed: _uploadFile,
                                child: const Row(children: [Text('Tambah foto '), FaIcon(FontAwesomeIcons.file, size: 16)]),
                              ),
                              ElevatedButton(
                                onPressed: _pickImageFromCamera,
                                child: const Row(children: [Text('Tambah Dari kamera '), FaIcon(FontAwesomeIcons.camera,size: 16,)]),
                              ),
                            ]),
                        CustomTheme.secondaryText('* File harus berupa image dengan ukuran < 2MB'),
                        Visibility(visible: _isPrevImageVisible, child: Center(child: SizedBox(height: 200,child: _prevImage),)),
                        ElevatedButton(onPressed: () =>sendData(context), child: const Text('Kirim'))
                      ],
                    )
                ),
              ],
            ),
          );
        },
    );
  }
}

class DropdownData extends StatefulWidget {
  final Function(String?) onChanged;
  final String endpoint;

  const DropdownData({super.key, required this.onChanged, this.endpoint = 'visibilitas'});

  @override
  _DropdownDataState createState() => _DropdownDataState();
}

class _DropdownDataState extends State<DropdownData> {
  String? _selectedValue;
  List<Map<String, dynamic>>? _dataList; // Add this variable to store fetched data
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpened = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      var result = await DataFetch.getPublicData(endpoint: widget.endpoint);
      if (result != null && result['data'] != null) {
        setState(() {
          _dataList = List<Map<String, dynamic>>.from(result['data']);
        });
      }
    } catch (error) {
      // Handle error
      print('Error fetching data: $error');
    }
  }

  void _toggleDropdown() {
    if (_isDropdownOpened) {
      _overlayEntry.remove();
      _isDropdownOpened = false;
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      _isDropdownOpened = true;
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 40, // Adjust width as necessary
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50), // Adjust offset as necessary
          child: Material(
            elevation: 8.0,
            child: _dataList == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _dataList!
                  .map((dataItem) => ListTile(
                  title: Text(dataItem[widget.endpoint == 'visibilitas' ? 'visibilitas' : 'jenis_pengaduan']),
                  onTap: () {
                    setState(() {
                      _selectedValue = dataItem[widget.endpoint == 'visibilitas' ? 'id_visibilitas' : 'id_jenispengaduan'];
                      widget.onChanged(_selectedValue);
                    });
                    _toggleDropdown();
                  },
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedValue == null
                    ? widget.endpoint == 'visibilitas' ? 'Pilih Privasi' : 'Pilih Status'
                    : _dataList!.firstWhere((dataItem) =>
                dataItem[widget.endpoint == 'visibilitas' ? 'id_visibilitas' : 'id_jenispengaduan'] == _selectedValue)[widget.endpoint == 'visibilitas' ? 'visibilitas' : 'jenis_pengaduan'],
              ),
              Icon(_isDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
