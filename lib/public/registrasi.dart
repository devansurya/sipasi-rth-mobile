import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/data.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => RegisterLayout();
}

class RegisterLayout extends State<RegisterView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController repeatPassController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void register(BuildContext context) async {
    try {
      if (emailController.text.isEmpty || passController.text.isEmpty || repeatPassController.text.isEmpty || nameController.text.isEmpty || phoneController.text.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Email, password, repeat password, name, and phone must not be empty.',
          backgroundColor: Colors.grey,
        );
        return;
      }

      if (passController.text != repeatPassController.text) {
        Fluttertoast.showToast(
          msg: 'Password and repeat password do not match.',
          backgroundColor: Colors.grey,
        );
        return;
      }

      final data = DataFetch();
      final response = await data.register(
        email: emailController.text,
        password: passController.text,
        nama: nameController.text,
        noTelp: phoneController.text,
        idRole: '3',
      );

      if (response != null && response['code'] == 200) {
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(
          msg: 'Registration failed. Please try again.',
          backgroundColor: Colors.grey,
        );
      }
    } catch (error) {
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset('assets/icons/logo.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Nama', fillColor: Colors.white),
                          controller: nameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Email', fillColor: Colors.white),
                          controller: emailController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Password', fillColor: Colors.white),
                          obscureText: true,
                          controller: passController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'Ulangi Password', fillColor: Colors.white),
                          obscureText: true,
                          controller: repeatPassController,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: 'No Telepon', fillColor: Colors.white),
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(width: double.infinity),
                          child: ElevatedButton(
                            onPressed: () {
                              register(context);
                            },
                            child: const Text('Register'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
