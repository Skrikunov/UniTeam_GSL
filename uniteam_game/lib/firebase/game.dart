import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniteam_game/firebase/auth.dart';
import '../firebase_options.dart'; // new

class PlayerState extends ChangeNotifier {
  PlayerState() {
    init();
  }
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user != null) {
        _email = user.email;
        _name = user.displayName;
        _roomId = (await FirebaseFirestore.instance
                .collection('users')
                .doc(_email)
                .get())
            .data()!["roomId"];
      }
      print("Room ID: ${_roomId}");
      if (roomId != null) {
        var slotData = (await FirebaseFirestore.instance
                .collection("rooms")
                .doc(_roomId)
                .collection("players")
                .doc(_email)
                .get())
            .data();
        print(slotData);
        _mySlots = slotData!['slots'];
        _monitoredSlot = slotData['monitoredSlot'];
        _item = slotData['item'];

        var slotsNum = (await FirebaseFirestore.instance
                .collection("rooms")
                .doc(_roomId)
                .collection("slots")
                .get())
            .docs
            .length;

        FirebaseFirestore.instance
            .collection("rooms")
            .doc(_roomId)
            .collection("players")
            .doc(_email)
            .update({"monitoredIsCorrect": false});
        FirebaseFirestore.instance
            .collection("rooms")
            .doc(_roomId)
            .collection("players")
            .where("monitoredIsCorrect", isEqualTo: true)
            .snapshots()
            .listen((snapshot) => {
                  if (snapshot.docs.length == slotsNum && _finishGame != null)
                    {_finishGame!()}
                });

        for (int slot = 0; slot < slotsNum; ++slot) {
          FirebaseFirestore.instance
              .collection("rooms")
              .doc(_roomId)
              .collection("slots")
              .doc(slot.toString())
              .collection("items")
              .snapshots()
              .listen((snapshot) {
            if (_monitoredSlot == slot) {
              _monitoredItems = [...snapshot.docs.map((e) => int.parse(e.id))];

              if (_monitoredItems!.length == 1 &&
                  _monitoredItems![0] == _monitoredSlot) {
                FirebaseFirestore.instance
                    .collection("rooms")
                    .doc(_roomId)
                    .collection("players")
                    .doc(_email)
                    .update({"monitoredIsCorrect": true});
              } else {
                FirebaseFirestore.instance
                    .collection("rooms")
                    .doc(_roomId)
                    .collection("players")
                    .doc(_email)
                    .update({"monitoredIsCorrect": false});
              }
            }

            notifyListeners();
          });
        }
      }
    });
  }

  String? _roomId;
  String? get roomId => _roomId;

  String? _email;
  String? get email => _email;

  String? _name;
  String? get name => _name;

  List<dynamic>? _mySlots;
  List<dynamic>? get mySlots => _mySlots;

  int? _item;
  int? get item => _item;

  int? _usedSlot;
  int? get usedSlot => _usedSlot;

  int? _monitoredSlot;
  int? get monitoredSlot => _monitoredSlot;

  List<int>? _monitoredItems;
  List<int>? get monitoredItems => _monitoredItems;

  StreamSubscription<QuerySnapshot>? _slotsSubscription;
  List<Slot> _slots = [];
  List<Slot> get slots => _slots;

  Function? _finishGame;

  bool setFinishGame(Function finish) {
    _finishGame = finish;
    return true;
  }

  Future<void> updateMonitoredSlotItems() async {
    if (_monitoredSlot != null) {
      List<int> items = [
        ...(await FirebaseFirestore.instance
                .collection("rooms")
                .doc(_roomId)
                .collection("slots")
                .doc(_monitoredSlot!.toString())
                .collection("items")
                .get())
            .docs
            .map((e) => int.parse(e.id))
      ];
      mergeSort(items);
      _monitoredItems = items;

      notifyListeners();
    }
  }

  Future<void> putItemToSlot(int cellNumber) async {
    if (_usedSlot != null) {
      FirebaseFirestore.instance
          .collection("rooms")
          .doc(_roomId)
          .collection("slots")
          .doc(_usedSlot!.toString())
          .collection("items")
          .doc(_item!.toString())
          .delete();
    }
    _usedSlot = _mySlots![cellNumber];

    FirebaseFirestore.instance
        .collection("rooms")
        .doc(_roomId)
        .collection("slots")
        .doc(_usedSlot!.toString())
        .collection("items")
        .doc(_item!.toString())
        .set({"item": _item!});

    notifyListeners();
  }
}

class Slot {
  Slot(
      {required this.items,
      required this.monitoringPlayer,
      required this.truePlayer});
  final String monitoringPlayer, truePlayer;
  final List<dynamic> items;
}
