import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qualification_work/firebase_options.dart';
import 'package:flutter_qualification_work/services/authentication/start_auth_service.dart';
import 'package:flutter_qualification_work/services/check_internet_service.dart';
import 'package:flutter_qualification_work/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightMode,
      darkTheme: darkMode,
      home: StartAuthService().handleAuthState(),
      //home: CheckInternet(widget: StartAuthService().handleAuthState(),),
    );
  }
}
