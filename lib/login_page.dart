import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginView(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => LoginLayout();
}

class LoginLayout extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 234, 234, 1.0),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(20.0), child: TextFormField(decoration: const InputDecoration(labelText: 'Email',fillColor: Colors.white),),),
                    Padding(padding: EdgeInsets.all(20.0), child: TextFormField(decoration: const InputDecoration(labelText: 'Password',fillColor: Colors.white),),),
                    Padding(padding: EdgeInsets.all(20.0), child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: double.infinity),
                      child: ElevatedButton(
                        onPressed: () {
                          // Your button action
                        },
                        child: Text('Login'),
                      ),
                    ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}