import 'package:flutter/material.dart';
import 'package:uniteam_game/screens/gamescreen.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen({Key? key, this.title = "Description"})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    final startButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color.fromRGBO(71, 195, 203, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DragGame()),
          );
        },
        child: Text("Start game!",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Back'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 10.0),
                    const Text('WHATS HAPPENING?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(54, 83, 110, 1),
                        )
                        // style: Theme.of(context).textTheme.headline4,
                        ),
                    const SizedBox(height: 20.0),
                    const Text(
                        'The crew of your spaceship crashed on the planet Nibiru. All people scattered across the planet. You survived and even found a part of the rocket, but you dont know which part of the body to attach it to. Use the help of friends: put together a rocket and save your life! BE CAREFUL: Oxygen is running out! Time has gone...',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(54, 83, 110, 1),
                        )
                        // style: Theme.of(context).textTheme.headline4,
                        ),
                    const SizedBox(height: 50.0),
                    SizedBox(
                      height: 300.0,
                      child: Image.asset(
                        "assets/rocket.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    startButon,
                    const SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
