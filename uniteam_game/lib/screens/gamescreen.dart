import 'package:flutter/material.dart';

void main() {
  runApp(const TeamBuilder());
}

class TeamBuilder extends StatelessWidget {
  const TeamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DragGame(),
    );
  }
}

class DragGame extends StatefulWidget {
  const DragGame({Key? key}) : super(key: key);

  @override
  _DragGameState createState() => _DragGameState();
}

class _DragGameState extends State<DragGame> {
   bool insideTarget1 = false;
   bool insideTarget2 = false;
   bool insideTarget3 = false;
   double  sizeBuilt = 120.0;
   Color cbuilt = Colors.cyan;

  @override
  Widget build(BuildContext context) {
    //bool insideTarget = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Builder? '),
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
    );
  }
}
