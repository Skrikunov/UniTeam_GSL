import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/material.dart';
// new
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniteam_game/screens/profile.dart';
import '../firebase_options.dart'; // new
import '../utils/authentication.dart'; // new

import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random.secure();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        _email = user.email;
        _name = user.displayName;
        print("User logged in with name " + _name!);
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });

    FirebaseFirestore.instance.collection("users").doc(_email).delete();
    notifyListeners();
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  String? _name;
  String? get name => _name;

  String? _roomId;
  String get roomId => _roomId ?? "none";

  int _readyPlayers = 0;
  int get readyPlayersCount => _readyPlayers;

  static const int _minPlayersNum = 4;
  int get minPlayersNum => _minPlayersNum;

  bool _ready = true;
  bool get ready => _ready;

  bool _isHost = false;
  bool get isHost => _isHost;

  bool _gameInitialized = false;
  bool get gameInitialized => _gameInitialized;

  StreamSubscription? _roomSubscription;

  StreamSubscription<QuerySnapshot>? _playerListSubscription;
  List<PlayerInRoom> _playerList = [];
  List<PlayerInRoom> get playerList => _playerList;

  StreamSubscription<QuerySnapshot>? _slotsSubscription;

  Function? _goToGameScreen;

  // TODO: Add moveItem function
  // TODO: Add initGame function to the profile screen
  // TODO: Add win check function

  Future<void> initGame() async {
    FirebaseFirestore.instance
        .collection("rooms")
        .doc(roomId)
        .set({"initialized": false}, SetOptions(merge: true));

    var items = [for (var i = 0; i < _playerList.length; i += 1) i];
    items.shuffle();

    bool success = false;
    var monitorSlots = [];
    while (!success) {
      monitorSlots = [];
      for (var i = 0; i < _playerList.length; i += 1) {
        var possibleSlots =
            items.toSet().difference({items[i], ...monitorSlots}).toList();
        possibleSlots.shuffle();
        if (possibleSlots.isEmpty) break;
        monitorSlots.add(possibleSlots[0]);
      }
      if (monitorSlots.length == _playerList.length) success = true;
    }
    print(monitorSlots);

    var slots = [
      for (var i = 0; i < _playerList.length; i += 1) [items[i]]
    ];
    for (var i = 0; i < _playerList.length; i += 1) {
      var possibleSlots =
          items.toSet().difference({monitorSlots[i], ...slots[i]}).toList();
      possibleSlots.shuffle();
      slots[i].addAll(possibleSlots.getRange(0, 2));
      slots[i].shuffle();
    }
    for (var i = 0; i != _playerList.length; ++i) {
      String monitoringPlayer = _playerList[monitorSlots.indexOf(i)].email;
      String truePlayer = _playerList[items.indexOf(i)].email;
      FirebaseFirestore.instance
          .collection("rooms")
          .doc(roomId)
          .collection("slots")
          .doc("$i")
          .set(
              {"monitoringPlayer": monitoringPlayer, "truePlayer": truePlayer});

      FirebaseFirestore.instance
          .collection("rooms")
          .doc(roomId)
          .collection("players")
          .doc(_playerList[i].email)
          .update({
        "slots": slots[i],
        "monitoredSlot": monitorSlots[i],
        "item": items[i]
      });
    }
    _gameInitialized = true;
    FirebaseFirestore.instance
        .collection("rooms")
        .doc(roomId)
        .update({"initialized": true});
  }

  Future<void> leaveRoom({bool deleteRoom = false}) async {
    FirebaseFirestore.instance
        .collection("rooms")
        .doc(_roomId)
        .collection("players")
        .doc(_email)
        .delete();

    FirebaseFirestore.instance.collection("users").doc(_email).delete();

    _slotsSubscription?.cancel();
    _playerListSubscription?.cancel();
    _roomSubscription?.cancel();

    _roomId = 'none';
    notifyListeners();
  }

  Future<void> subscribeForRoom() async {
    var firestore = FirebaseFirestore.instance;
    firestore.collection("users").doc(_email).set({"roomId": roomId});
    _roomSubscription = firestore
        .collection("rooms")
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data()?["initialized"]) {
        _gameInitialized = true;
        _goToGameScreen!();
      }
    });
    _playerListSubscription = firestore
        .collection("rooms")
        .doc(roomId)
        .collection("players")
        .snapshots()
        .listen((snapshot) {
      _playerList = [];
      _readyPlayers = 0;
      for (final document in snapshot.docs) {
        _playerList.add(
          PlayerInRoom(
            email: document.data()['email'] as String,
            name: document.data()['name'] as String,
            ready: document.data()['ready'] as bool,
          ),
        );
        if (document.data()['ready']) _readyPlayers += 1;
      }

      if ((_playerList.length == _readyPlayers) &&
          (_readyPlayers >= _minPlayersNum) &&
          !_gameInitialized &&
          _isHost) {
        print("${_email} is initializing the game... ");
        initGame();
      }
      notifyListeners();
    });
  }

  Future<void> removeRoom() async {
    leaveRoom();
  }

  Future<void> setReady(
    void Function(Exception e) errorCallback,
  ) async {
    try {
      _ready = !_ready;
      FirebaseFirestore.instance
          .collection("rooms")
          .doc(roomId)
          .collection("players")
          .doc(_email)
          .update({"ready": _ready});
      notifyListeners();
    } on Exception catch (e) {
      errorCallback(e);
    }
  }

  Future<void> joinRoom(
    String formRoomId,
    void Function() goToGameScreen,
    void Function(Exception e) errorCallback,
  ) async {
    try {
      if ((await FirebaseFirestore.instance
              .collection("rooms")
              .doc(formRoomId)
              .get())
          .exists) {
        FirebaseFirestore.instance
            .collection("rooms")
            .doc(formRoomId)
            .collection("players")
            .doc(_email)
            .set({"name": _name, "email": _email, "ready": _ready});
        _roomId = formRoomId;
        subscribeForRoom();
        notifyListeners();
        _goToGameScreen = goToGameScreen;
      } else {
        errorCallback(Exception(
            "Failed joining the room. Probably the room id is wrong."));
      }
    } on Exception catch (e) {
      errorCallback(e);
    }
  }

  Future<void> createRoom(
    void Function() goToGameScreen,
    void Function(Exception e) errorCallback,
  ) async {
    try {
      final String id = getRandomString(3);
      var ref = FirebaseFirestore.instance;
      ref.collection("rooms").doc(id).set({"initialized": false});
      ref
          .collection("rooms")
          .doc(id)
          .collection("players")
          .doc(_email)
          .set({"name": _name, "email": _email, "ready": _ready});

      _roomId = id;
      _isHost = true;
      subscribeForRoom();

      notifyListeners();
      _goToGameScreen = goToGameScreen;
    } on Exception catch (e) {
      errorCallback(e);
    }
  }

  Future<void> verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.loggedOut;
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
