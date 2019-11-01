import 'package:chat_app_starter/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomsScreen extends StatefulWidget {
  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  //variables for RoomsScreen
  FirebaseUser currentUser;
  final roomIdController = TextEditingController();
  CollectionReference rooms = Firestore.instance.collection('rooms');
  String roomId;
  //init state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  //RoomsScreen build method
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    controller: roomIdController,
                  ),
                ),
                RaisedButton(
                  child: Text('Join Room'),
                  //TODO: add room id from controller value
                  onPressed: roomIdController.text.isEmpty
                      ? null
                      : () {
                          String tempRoomId = roomIdController.text;
                          roomIdController.clear();
                          roomId = tempRoomId;
                          Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(roomId)));
                        },
                ),
              ],
            ),
            RaisedButton(
              child: Text('Create New Room'),
              onPressed: () {
                Firestore.instance.collection('rooms').add({'roomID': '008'});
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Colors.purple,
                  child: Text('Log in'),
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                ),
                FlatButton(
                  child: Text('test button'),
                  color: Colors.purple,
                  onPressed: () async {
//                    QuerySnapshot y = await Firestore.instance
//                        .collection('rooms')
//                        .getDocuments();
//                    print('-----------');
//                    print(y.documents);
                    rooms.document('0002').collection('messages').add({
                      'senderEmail': 'kapil@gmail.com',
                      'text': 'sample text',
                      'time': DateTime.now()
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

//  void sendMessageTOSubCollection() async {
//    String temp = 'test01 sending message to subcollection ';
//    await Firestore.instance.collection('rooms').;
//  }
}
