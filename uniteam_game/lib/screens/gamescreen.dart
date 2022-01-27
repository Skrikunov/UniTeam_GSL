import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniteam_game/firebase/auth.dart';
import 'package:uniteam_game/firebase/game.dart';
import 'package:uniteam_game/screens/winner.dart';

class DragGame extends StatefulWidget {
  const DragGame({Key? key}) : super(key: key);

  @override
  _DragGameState createState() => _DragGameState();
}

class _DragGameState extends State<DragGame> {
  int? occupiedSlot;
  Color cbuilt = Colors.cyan;
  List<String> rocketPartsAssetURLs = [
    'rocket_head.png',
    'rocket_body.png',
    'rocket_low.png',
    'rocket_tail.png'
  ];
  String fullRocketAssetURL = 'full_rocket.jpg';

  @override
  Widget build(BuildContext context) {
    //bool insideTarget = false;
    void goToWinScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WinScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            occupiedSlot = null;
          });
        },
      ),
      body: Center(
          child: Consumer<PlayerState>(
        builder: (context, playerState, _) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  const Text("Slot 1"),
                  DragTarget<String>(builder: (context, data, rejectedDate) {
                    return Container(
                        padding: const EdgeInsets.all(8.0),
                        width: 100,
                        height: 100,
                        // color: Colors.orange,
                        color: occupiedSlot == 0 ? cbuilt : Colors.orange,
                        child: occupiedSlot == 0
                            ? Image.asset(
                                rocketPartsAssetURLs[playerState.item ?? 0])
                            : null);
                  }, onAccept: (data) {
                    setState(() {
                      occupiedSlot = 0;
                      playerState.putItemToSlot(occupiedSlot!);
                    });
                  })
                ]),
                Column(children: [
                  const Text("Slot 2"),
                  DragTarget<String>(builder: (context, data, rejectedDate) {
                    return Container(
                      width: 100,
                      height: 100,
                      // color: Colors.orange,
                      color: occupiedSlot == 1 ? cbuilt : Colors.orange,
                      child: occupiedSlot == 1
                          ? Image.asset(
                              rocketPartsAssetURLs[playerState.item ?? 0])
                          : null,
                    );
                  }, onAccept: (data) {
                    setState(() {
                      occupiedSlot = 1;
                      playerState.putItemToSlot(occupiedSlot!);
                    });
                  })
                ]),
                Column(children: [
                  const Text("Slot 3"),
                  DragTarget<String>(builder: (context, data, rejectedDate) {
                    return Container(
                      width: 100,
                      height: 100,
                      // color: Colors.orange,
                      color: occupiedSlot == 2 ? cbuilt : Colors.orange,
                      child: occupiedSlot == 2
                          ? Image.asset(
                              rocketPartsAssetURLs[playerState.item ?? 0])
                          : null,
                    );
                  }, onAccept: (data) {
                    setState(() {
                      occupiedSlot = 2;
                      playerState.putItemToSlot(occupiedSlot!);
                    });
                  }),
                ])
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                playerState.setFinishGame(goToWinScreen)
                    ? const Text("")
                    : const Text(""),
                Column(children: [
                  const Text("Your part"),
                  Draggable(
                    data: 'data',
                    child: Container(
                      height: 120,
                      width: 120,
                      color: Colors.white,
                      child: Image.asset(
                          rocketPartsAssetURLs[playerState.item ?? 0]),
                    ),
                    feedback: Container(
                      height: 60,
                      width: 60,
                      color: Colors.white,
                      child: Image.asset(
                          rocketPartsAssetURLs[playerState.item ?? 0]),
                    ),
                    childWhenDragging: Container(
                      height: 120,
                      width: 120,
                      color: Colors.grey,
                    ),
                  ),
                ]),
                const SizedBox(width: 120),
                if (playerState.monitoredSlot != null)
                  Column(children: [
                    const Text("Correct part for this slot:"),
                    Image.asset(
                        rocketPartsAssetURLs[playerState.monitoredSlot!],
                        width: 60,
                        height: 60),
                  ]),
                Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.grey,
                    child: Row(
                      children: [
                        for (var item in playerState.monitoredItems ?? [])
                          Image.asset(rocketPartsAssetURLs[item],
                              width: 60, height: 60)
                      ],
                    ))
              ],
            )
          ],
        ),
      )),
    );
  }
}
