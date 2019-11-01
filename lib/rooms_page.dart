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
  List roomsList = [];
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

  Future getRoomsList() async {
    QuerySnapshot rooms =
        await Firestore.instance.collection('rooms').getDocuments();
//TODO: list of rooms method 2
    for (DocumentSnapshot roomID in rooms.documents) {
      roomsList.add(roomID.documentID);
    }
    print(roomsList);
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
            Expanded(
              flex: 7,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('rooms').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(16, 2, 16, 0),
                          child: RaisedButton(
                              onPressed: () async {
                                Firestore.instance
                                    .collection('rooms')
                                    .document(
                                        '${snapshot.data.documents[index].documentID}')
                                    .collection('messages');
                                Navigator.push(
                                    (context),
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                            snapshot.data.documents[index]
                                                .documentID)));
                              },
                              child: Text(
                                snapshot.data.documents[index].documentID,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              color: Colors.lightGreen),
                        );
                      },
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                    );
                  }
                },
              ),
            ),
//            SizedBox(
//              height: 10,
//            ),
            Expanded(
              flex: 1,
              child: Row(
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
                        : () async {
                            String tempRoomId = roomIdController.text;
                            roomIdController.clear();
                            roomId = tempRoomId;
                            roomsList = [];
                            await getRoomsList();
                            if (roomsList.contains(roomId)) {
                              Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatScreen(roomId)));
                            } else {
                              print('No room by such ID. please try again');
                            }
                          },
                  ),
                ],
              ),
            ),
//            SizedBox(
//              height: 10,
//            ),
            // create new room button
            Expanded(
              flex: 1,
              child: RaisedButton(
                color: Colors.purple,
                elevation: 5,
                child: Text('Create New Room'),
                onPressed: () async {
                  int randomNumber = 1111 + Random().nextInt(888);
                  roomId = randomNumber.toString();
                  if (roomsList.contains(roomId)) {
                    print("current Room Id already exits, try again");
                  } else {
                    Firestore.instance
                        .collection('rooms')
                        .document(roomId)
                        .setData({'roomID': roomId, 'time': DateTime.now()});
                    Navigator.push(
                        (context),
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(roomId)));
                  }
                },
              ),
            ),
//            SizedBox(
//              height: 10,
//            ),
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
