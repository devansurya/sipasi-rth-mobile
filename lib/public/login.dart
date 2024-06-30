import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/dashboard/Index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/data.dart';
import '../app_state.dart';
import '../helper/Helper.dart';
import 'registrasi.dart'; // Pastikan Anda memiliki halaman register yang sesuai


class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => LoginLayout();
}

class LoginLayout extends State<LoginView> {

  final bool _passwordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController assetsUrlController = TextEditingController();
  late Future<dynamic> _getbaseUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getbaseUrl = DataFetch.getUrls();
  }

  void openDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => FutureBuilder(future: _getbaseUrl, builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Helper.circleIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          var data =snapshot.data;
          log(data.toString());
          urlController.text = data['baseUrl'] ?? '';
          assetsUrlController.text = data['assetsUrl'] ?? '';

          return AlertDialog(
            title: const Text('Setting'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: [
                    const Text('Url Api : '),
                    Row(children: [Expanded(child: TextField(keyboardType: TextInputType.url,controller: urlController))]),
                    const Text('Url Assets : '),
                    Row(children: [Expanded(child: TextField(keyboardType: TextInputType.url,controller: assetsUrlController))])
                  ],
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                //child: const Text('OK'),
                child: const Text('Save'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Helper.button('Save', callback: () async {
                var data = await DataFetch.updateBaseUrl(urlController.text);
                var data2 = await DataFetch.updateAssetsUrl(assetsUrlController.text);
                if(data && data2) {
                  Navigator.pop(context);
                  setState(() {
                    _getbaseUrl = DataFetch.getUrls();
                  });
                  Helper.showSuccessSnackbar(context, 'Success Update url');
                }
              })
            ],
          );
        }
      }),
    );
  }

  void checkLogin(BuildContext context) async {
    try {
      if (emailController.text.isEmpty || passController.text.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Email and password must not be empty.',
          backgroundColor: Colors.grey,
        );
        return;
      }
      final data = DataFetch();
      final response = await data.login(email: emailController.text, pass: passController.text);
      final appState = Provider.of<AppState>(context,listen: false);
      if (response != null && response['code'] == 200) {
        emailController.text = '';
        passController.text = '';
        appState.setUserData(response['data']['user']);
        if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (context) => const Index()));
      } else {
        Fluttertoast.showToast(
          msg: 'Login failed. Please check your credentials.',
          backgroundColor: Colors.grey,
        );
      }
    } catch (error) {
      log(error.toString());
      Fluttertoast.showToast(
        msg: error.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.grey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(234, 234, 234, 1.0),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.all(20.0), child: Image.asset('assets/icons/logo.png')),
                      Padding(padding: const EdgeInsets.all(20.0), child: TextFormField(decoration: const InputDecoration(labelText: 'Email',fillColor: Colors.white),controller: emailController,),),
                      Padding(padding: const EdgeInsets.all(20.0), child: TextFormField(decoration: const InputDecoration(labelText: 'Password',fillColor: Colors.white), obscureText: true,controller: passController,),),
                      Padding(padding: const EdgeInsets.all(20.0), child: ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(width: double.infinity),
                        child: ElevatedButton(
                          onPressed: () {
                            checkLogin(context);
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // This will space the widgets evenly
                          children: [
                            TextButton(
                                onPressed: () async {
                                  // Navigate to the registration page
                                  var data = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterView()),
                                  );
                                  if(data) {
                                    Helper.showSuccessSnackbar(context, 'Silahkan Login');
                                  }
                                },
                                child: const Text('Register')
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton:  FloatingActionButton(onPressed:() =>  openDialog(context),mini: true,backgroundColor: Colors.white,enableFeedback: true, child: const Icon(Icons.settings,color: Colors.green,)),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop
    );
  }
}
