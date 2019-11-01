import 'package:chat_app_starter/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

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
    roomIdController.addListener(() {
      setState(() {});
    });
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
          mainAxisAlignment: MainAxisAlignment.center,
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
                // join room button
                RaisedButton(
                  child: Text('Join Room'),
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
            // create new room button
            RaisedButton(
              child: Text('Create New Room'),
              onPressed: () {
                int randomNumber = 1111 + Random().nextInt(888);
                roomId = randomNumber.toString();
                Navigator.push(
                    (context),
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(roomId)));
              },
            ),
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
