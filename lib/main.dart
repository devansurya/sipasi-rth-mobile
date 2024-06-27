import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:sipasi_rth_mobile/helper/database.dart';
import 'package:sipasi_rth_mobile/public/login.dart';
import 'dashboard/Index.dart';
import 'api/data.dart';
import 'app_state.dart';
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
  const MyApp({super.key, required  this.isLoggedIn});

  _defaultView(bool isLoggedIn) {
    if(isLoggedIn) {
      return const Index();
    }
    else {
      return const LoginView();
    }
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child :MaterialApp(
        title: dotenv.get('APP_NAME_SHORT'),
        theme: ThemeData(
          fontFamily: 'Urbanist',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, background: Colors.white),
          useMaterial3: true,
            bottomSheetTheme:  const BottomSheetThemeData(backgroundColor: Colors.white)
        ),
        home: _defaultView(isLoggedIn),
      )
    );
  }
}
