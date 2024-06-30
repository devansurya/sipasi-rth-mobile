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

  void openDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setting'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            //child: const Text('OK'),
            child: const Text('Save'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
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
