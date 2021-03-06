import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'Screens/description.dart';
import 'Screens/profile.dart';
import 'Screens/login.dart';
import 'Screens/register.dart';
import 'Screens/loading.dart';
import 'Screens/gamescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniTeam: Login',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.cyan,
        // fontFamily: 'Montserrat',
      ),
      // JUST UNCOMMENT TEAMMANAGER AND COMMENT LOADING PAGE
      // FOR FAST TESTING
      home: MyLoadingPage(title: 'UniTeam Login'),
      // home: MyTeamManager(title: 'UniTeam Login'),
    );
  }
}



