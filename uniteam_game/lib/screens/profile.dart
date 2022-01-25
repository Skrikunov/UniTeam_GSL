import 'package:flutter/material.dart';
import 'description.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, this.title = "Profile"}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

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
      color: Color.fromRGBO(71, 195, 203, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DescriptionScreen()),
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
          title: Text('Back'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            ),
            IconButton(
              icon: Icon(
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
                    const Text('PROFILE',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(54, 83, 110, 1),
                        )
                        // style: Theme.of(context).textTheme.headline4,
                        ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      height: 300.0,
                      child: Image.asset(
                        "assets/avatar.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    const Text('Your avatar',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(54, 83, 110, 1),
                        )
                        // style: Theme.of(context).textTheme.headline4,
                        ),
                    const Text('Welcome, Stas',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          color: Color.fromRGBO(54, 83, 110, 1),
                        )
                        // style: Theme.of(context).textTheme.headline4,
                        ),
                    SizedBox(
                      height: 200.0,
                    ),
                    startButon,
                    SizedBox(
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
