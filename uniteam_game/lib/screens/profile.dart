import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniteam_game/firebase/auth.dart';
import 'package:uniteam_game/screens/gamescreen.dart';
import 'package:uniteam_game/utils/authentication.dart';
import 'package:uniteam_game/utils/widgets.dart';
import 'description.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.title = "Profile"}) : super(key: key);
  final String title;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    void goToGameScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DescriptionScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            child: Consumer<ApplicationState>(
                builder: (context, appState, _) => (appState.loginState ==
                        ApplicationLoginState.loggedIn)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (appState.roomId == "none")
                            Column(children: [
                              JoinRoomForm(callback: (roomId) {
                                appState.joinRoom(
                                    roomId,
                                    goToGameScreen,
                                    (e) => _showErrorDialog(context,
                                        'Failed to enter room' + roomId, e));
                              }),
                              StyledButton(
                                  child: const Text(
                                    "Create new room",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    appState.createRoom(
                                        goToGameScreen,
                                        (e) => _showErrorDialog(context,
                                            'Failed to create room', e));
                                  }),
                            ])
                          else
                            Column(children: [
                              Header("Room ID: ${appState.roomId}"),
                              Paragraph(
                                  "${appState.playerList.length} players total."),
                              if (appState.readyPlayersCount >= 2)
                                Paragraph(
                                    '${appState.readyPlayersCount} people are ready')
                              else if (appState.readyPlayersCount == 1)
                                const Paragraph('1 person is ready')
                              else
                                const Paragraph('No one is ready'),
                              for (final player in appState.playerList)
                                Row(
                                  children: [
                                    Paragraph(player.name),
                                    const SizedBox(width: 20),
                                    Paragraph("Ready: ${player.ready}"),
                                    const SizedBox(width: 20),
                                    if (appState.isHost &&
                                        player.email == appState.email)
                                      Paragraph("Host")
                                  ],
                                ),
                              StyledButton(
                                  child: Text(
                                    appState.ready
                                        ? "Set Not Ready"
                                        : "Set Ready",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    appState.setReady((e) => _showErrorDialog(
                                        context, 'Failed to create room', e));
                                  }),
                              StyledButton(
                                  child: const Text(
                                    "Leave room",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: appState.leaveRoom),
                            ]),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      )
                    : Authentication(
                        email: appState.email,
                        loginState: appState.loginState,
                        verifyEmail: appState.verifyEmail,
                        signInWithEmailAndPassword:
                            appState.signInWithEmailAndPassword,
                        cancelRegistration: appState.cancelRegistration,
                        registerAccount: appState.registerAccount,
                        signOut: appState.signOut,
                      )),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}

class JoinRoomForm extends StatefulWidget {
  const JoinRoomForm({required this.callback});
  final void Function(String roomId) callback;
  @override
  _JoinRoomFormState createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends State<JoinRoomForm> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_JoinRoomFormState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header('Join room with room ID'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter room ID',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter room ID to continue';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 30),
                      child: StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.callback(_controller.text);
                          }
                        },
                        child: const Text('Enter'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PlayerInRoom {
  PlayerInRoom({required this.name, required this.email, required this.ready});
  final String name, email;
  final bool ready;
}
