import 'package:flutter/material.dart';
import 'package:flutter_login_ui/Screens/winner.dart';
import 'winner.dart';
import 'loading.dart';


class MyTeamManager extends StatefulWidget {
  MyTeamManager({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyTeamManager createState() => _MyTeamManager();
}

class _MyTeamManager extends State<MyTeamManager> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String dropdownvalue = 'Exit';
  var items =  ['Exit','New game'];

  final _clmns = 4;
  final _crds = 4;


  bool insideTarget1 = false;
  bool insideTarget2 = false;
  bool insideTarget3 = false;
  double  sizeBuilt = 120.0;
  Color cbuilt = Colors.cyan;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyWinPage()),
                );              },
            ),
            DropdownButton(
              value: dropdownvalue,
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              items:items.map((String items) {
                return DropdownMenuItem(
                    value: items,
                    child: Text(items)
                );
              }
              ).toList(),
              onChanged: (String newValue) {
                setState(() {
                  // dropdownvalue = newValue;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyLoadingPage()),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyWinPage()),
                  );
                });
                // do something
              },
            )
          ],
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: (){
          setState(() {
            insideTarget1 = false;
            insideTarget2 = false;
            insideTarget3 = false;
            sizeBuilt = 120.0;
          });
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DragTarget<String>(
                    builder: (context, data, rejectedDate){
                      return Container(
                        width: 100,
                        height: 100,
                        // color: Colors.orange,
                        color: !insideTarget1 ? Colors.orange : cbuilt,
                        child: !insideTarget1 ? const Text('O2 levels are falling') : const Text('Good job!') ,
                      );
                    },
                    onAccept: (data){
                      setState(() {
                        insideTarget1 = true;
                        sizeBuilt = 0;
                      });
                    }
                ),
                DragTarget<String>(
                    builder: (context, data, rejectedDate){
                      return Container(
                        width: 100,
                        height: 100,
                        // color: Colors.orange,
                        color: !insideTarget2 ? Colors.orange : cbuilt,
                        child: !insideTarget2 ? const Text('O2 levels are falling') : const Text('Good job!') ,
                      );
                    },
                    onAccept: (data){
                      setState(() {
                        insideTarget2 = true;
                        sizeBuilt = 0;
                      });
                    }
                ),
                DragTarget<String>(
                    builder: (context, data, rejectedDate){
                      return Container(
                        width: 100,
                        height: 100,
                        // color: Colors.orange,
                        color: Colors.orange,
                        child: !insideTarget3 ? const Text('O2 levels are falling') : const Text('Try again') ,
                      );
                    },
                    onAccept: (data){
                      setState(() {
                        insideTarget3 = true;
                        // sizeBuilt = 0;
                      });
                    }
                ),

              ],
            ),
            Draggable(
              data: 'data',
              child: Container(
                height: sizeBuilt,
                width: sizeBuilt,
                color: Colors.cyan,
                child: const Text('Save the crew'),
              ),
              feedback: Container(
                height: 120,
                width: 120,
                color: Colors.amber,
                child: const Text('Hurry !!!'),
              ),
              childWhenDragging: Container(
                height: 120,
                width: 120,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
        // body: SingleChildScrollView(
        //   child: Center(
        //     child: Container(
        //       color: Colors.white,
        //       child: Padding(
        //         padding: const EdgeInsets.all(36.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: <Widget>[
        //             const Text(
        //                 'GAME',
        //                 style: const TextStyle(
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 28,
        //                   fontStyle: FontStyle.normal,
        //                   color: Color.fromRGBO(54, 83, 110, 1),
        //
        //                 )
        //               // style: Theme.of(context).textTheme.headline4,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // )
    );
  }
}