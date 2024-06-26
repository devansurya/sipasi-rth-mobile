import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sipasi_rth_mobile/dashboard/component/ImageApi.dart';
import 'package:sipasi_rth_mobile/helper/Helper.dart';
import '../../api/data.dart';
import 'package:file_picker/file_picker.dart';

import '../../helper/CustomTheme.dart';

class FormPengaduan extends StatefulWidget {
  final String type;
  final int? id;
  final String? idPengaduan;

  const FormPengaduan({super.key, this.type = 'New', this.id, this.idPengaduan});


  @override
  _FormPengaduanState createState() => _FormPengaduanState(idPengaduan);
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
  bool _isNameDisabled = false;
  bool _isEmailDisabled = false;
  bool _isImageChanged = false;
  final String? idPengaduan;
  String? _defaultPengaduan;
  String? _defaultPrivasi;
  bool _isLoaded = false;


  _FormPengaduanState(String? this.idPengaduan);
  late Future<dynamic> _myFuture;

  @override
  void initState() {
    super.initState();
    _myFuture = DataFetch.getDetailPengaduan(idPengaduan: idPengaduan);
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
        final String method = idPengaduan != null ? 'PATCH' : 'POST' ;
        var response = await DataFetch.sendData(endpoint: 'Pengaduan',formData: formdata,file: _file, method: method);
        if(response != null) {
          Navigator.pop(context, true);
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
        _isImageChanged=true;
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
        _isImageChanged=true;
        _prevImage = Image.file(imageFile);
        _isPrevImageVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _myFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Helper.circleIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          else {
            if(snapshot.data['userdata'] != null && snapshot.data['pengaduan'] == null) {
              nameController.text = snapshot.data['userdata']['nama'] ?? '';
              emailController.text = snapshot.data['userdata']['email'] ?? '';
              if(nameController.text.isNotEmpty){
                _isNameDisabled = true;
              }
              if(emailController.text.isNotEmpty){
                _isEmailDisabled = true;
              }
              formdata['id_user'] = snapshot.data['userdata']['id_user'];
            }
            if(snapshot.data['pengaduan'] != null && !_isLoaded) {
              var pengaduanData = snapshot.data['pengaduan']['data'];
              nameController.text = pengaduanData['nama_pengadu'] ?? pengaduanData['nama'] ?? '';
              emailController.text = pengaduanData['email_pengadu'] ?? pengaduanData['email'] ?? '';

              if(nameController.text.isNotEmpty){
                _isNameDisabled = true;
              }
              if(emailController.text.isNotEmpty){
                _isEmailDisabled = true;
              }
              judulController.text = pengaduanData['subjek'] ?? '';
              deskripsiController.text = pengaduanData['deskripsi_pengaduan'] ?? '';
              lokasiController.text = pengaduanData['lokasi'] ?? '';
              if(pengaduanData['foto'] != '') {
                _prevImage = ImageApi(Url: pengaduanData['foto'], useBaseUrl: true, defaultImage:"assets/images/default-card.jpg");
                _isPrevImageVisible = true;
              }
              _defaultPrivasi = pengaduanData['visibilitas'];
              _defaultPengaduan = pengaduanData['id_jenispengaduan'];

              _isLoaded=true;
            }

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
                          TextField(controller: nameController,readOnly: _isNameDisabled,),
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
                          TextField(controller: emailController, readOnly: _isEmailDisabled,),
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
                          DropdownData(onChanged: (value) => updateFormData('visibilitas', value),defaultselectedValue: _defaultPrivasi),
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
                          DropdownData(onChanged: (value) => updateFormData('jenis_pengaduan', value),endpoint: 'jenis_pengaduan',defaultselectedValue: _defaultPengaduan,),
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
          }
        },
    );
  }
}

class DropdownData extends StatefulWidget {
  final Function(String?) onChanged;
  final String endpoint;
  final String? defaultselectedValue;

  const DropdownData({super.key, required this.onChanged, this.endpoint = 'visibilitas', this.defaultselectedValue});

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
    fetchData(widget.defaultselectedValue);
  }

  void fetchData(defValue) async {
    try {
      var result = await DataFetch.getPublicData(endpoint: widget.endpoint);
      if (result != null && result['data'] != null) {
        setState(() {
          if(defValue !=null) {
            _selectedValue = defValue;
            widget.onChanged(_selectedValue);
          }
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
              ).toList(),
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
