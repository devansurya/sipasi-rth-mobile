import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/helper/database.dart';
import 'admin/index.dart';
import 'api/data.dart';
import 'app_state.dart';
import 'login_page.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await DB.instance.database;
  await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromRGBO(234, 234, 234, 0.0),
  ));
  final bool isLoggedIn = await DataFetch.checkLogin() ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required  bool this.isLoggedIn});

  _defaultView(bool isLoggedIn) {
    if(isLoggedIn) {
      return Index();
    }
    else {
      return LoginView();
    }
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child :MaterialApp(
        title: dotenv.get('APP_NAME_SHORT'),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(), // Use default transition for iOS
            },
          ),
        ),
        home: _defaultView(isLoggedIn),
      )
    );
  }
}
