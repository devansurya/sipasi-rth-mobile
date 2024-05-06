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

  //

}

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => LoginLayout();
}

class LoginLayout extends State<LoginView> {

  bool _passwordVisible = false;

  void openDialog(BuildContext context) {

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Test Modal'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Text('Base url'),
                //
              ],
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            //child: const Text('OK'),
            child: Text('Save'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

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
                    Padding(padding: EdgeInsets.all(20.0), child: Image.asset('assets/icons/logo.png')),
                    // const Padding(padding: EdgeInsets.all(20.0), child: Text(
                    //   'Login', // Your title text
                    //   style: TextStyle(
                    //     fontSize: 24.0, // Adjust font size as needed
                    //     fontWeight: FontWeight.bold, // Make text bold (optional)
                    //     color: Colors.green, // Set color to green
                    //   ),
                    // ),),
                    Padding(padding: EdgeInsets.all(20.0), child: TextFormField(decoration: const InputDecoration(labelText: 'Email',fillColor: Colors.white),),),
                    Padding(padding: EdgeInsets.all(20.0), child: TextFormField(decoration: const InputDecoration(labelText: 'Password',fillColor: Colors.white), obscureText: true,),),
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
                    Padding(padding: EdgeInsets.all(20.0), child: Row(
                      children: [
                        TextButton(onPressed: null, child: Text('Forget Password'))
                      ],
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton:  FloatingActionButton(child: Icon(Icons.settings,color: Colors.green,),onPressed:() =>  openDialog(context),mini: true,backgroundColor: Colors.white,enableFeedback: true),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop
    );
  }


}

