import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_safety_final_project/child/Dashboard.dart';
import 'package:women_safety_final_project/child/child_login_screen.dart';
import 'package:women_safety_final_project/db/shared_pref.dart';
import 'package:women_safety_final_project/parent/parent_home_screen.dart';
import 'utils/constants.dart';

final navigatorkey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await MySharedPreference.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Women Safety App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.firaSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: MySharedPreference.getUserType(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == "") {
            return LoginScreen();
          }
          if (snapshot.data == "child") {
            return Dashboard();
          }
          if (snapshot.data == "parent") {
            return ParentHomeScreen();
          }

          return progressIndicator(context);
        },
      ),
    );
  }
}


// Future<bool> isAppOpeningForFirstTime() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool result = prefs.getBool("appOpenedBefore") ?? false;
//     if (!result) {
//       prefs.setBool("appOpenedBefore", true);
//     }
//     return result;
//   }  
