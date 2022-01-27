import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:uniteam_game/screens/waiting.dart';
import 'firebase/game.dart';
import 'screens/description.dart';
import 'screens/gamescreen.dart';
import 'screens/profile.dart';
import 'firebase/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // you must first provider the object that will be passed to the proxy
        ChangeNotifierProvider<ApplicationState>(
            create: (_) => ApplicationState()),
        ChangeNotifierProvider<PlayerState>(create: (_) => PlayerState()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniTeam',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ProfileScreen(),
        '/game': (context) => const DragGame(),
      },
    );
  }
}
