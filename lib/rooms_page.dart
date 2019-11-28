import 'package:chat_app_starter/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';


class RoomsScreen extends StatefulWidget {
  @override
  _RoomsScreenState createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List roomsList = [];
  //variables for RoomsScreen
  FirebaseUser currentUser;
  final roomIdController = TextEditingController();
  final roomNameController = TextEditingController();
  CollectionReference rooms = Firestore.instance.collection('rooms');
  String roomId;
  String roomName;
  //init state
  @override
  void initState() {
    roomIdController.addListener(() {
      setState(() {});
    });
    roomNameController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  Future getRoomsList() async {
    roomsList = [];
    await Firestore.instance.collection('rooms').getDocuments();
    QuerySnapshot rooms =
        await Firestore.instance.collection('rooms').getDocuments();
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
    final _showToast =
        (x) => Fluttertoast.showToast(msg: x, toastLength: Toast.LENGTH_SHORT);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat Rooms'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('rooms').orderBy('name').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                padding: EdgeInsets.only(top: 15),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(25, 2, 25, 0),
                    child: Card(
                      child: ListTile(
                        trailing: Icon(Icons.arrow_forward_ios),
                        leading: Icon(
                          Icons.group,
                          size: 35,
                        ),
                        onTap: () async {
                          Firestore.instance
                              .collection('rooms')
                              .document(
                                  '${snapshot.data.documents[index].documentID}')
                              .collection('messages');
                          Navigator.push(
                              (context),
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(snapshot
                                      .data.documents[index].documentID)));
                        },
                        subtitle: Text(
                          'ID:${snapshot.data.documents[index].documentID}',
                          style: TextStyle(color: Colors.black38, fontSize: 16),
                        ),
                        title: snapshot.data.documents[index].data['name'] !=
                                null
                            ? Text(snapshot.data.documents[index].data['name'])
                            : Text('No Name'),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
              );
            }
            
          },
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Join or Create New Room',
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Create Room'),
                              Spacer(),
                              Icon(Icons.add),
                            ],
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            int randomNumber = 1111 + Random().nextInt(888);
                            roomId = randomNumber.toString();
                            if (roomsList.contains(roomId)) {
                              print("current Room Id already exits, try again");
                              _showToast(
                                  "current Room Id already exits, try again");
                            } else {
                              // create room button, randomly generated ID is new and doesn't already exist.
                              //pop up asking user to given name to room
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('Enter Room Name'),
                                        content: TextField(
                                          showCursor: true,
                                          controller: roomNameController,
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: () async {
                                              String tempRoomName =
                                                  roomNameController.text;
                                              print(
                                                  'tempRoomName:$tempRoomName');
                                              print(
                                                  'roomController tetx: ${roomNameController.text}');
                                              roomNameController.clear();
                                              roomName = tempRoomName;
                                              print(
                                                  'trying to join room $roomId roomName $roomName');

                                              Firestore.instance
                                                  .collection('rooms')
                                                  .document(roomId)
                                                  .setData({
                                                'roomID': roomId,
                                                'time': DateTime.now(),
                                                'name': roomName
                                              });
                                              Navigator.pushReplacement(
                                                  (context),
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatScreen(roomId)));
                                            },
                                          )
                                        ],
                                      ));

                              //after getting random roomID and roomName from user

                            }
                          },
                        ),
                        ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('Join'),
                                Spacer(),
                                Icon(Icons.merge_type),
                              ],
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              print('here now 1');
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('Enter Room ID'),
                                        content: TextField(
                                          controller: roomIdController,
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Join'),
                                            onPressed: () async {
                                              print('here now 1');
                                              String tempRoomId =
                                                  roomIdController.text;
                                              roomIdController.clear();
                                              roomId = tempRoomId;
                                              print(
                                                  'trying to join room $roomId');

                                              await getRoomsList();
                                              if (roomsList.contains(roomId)) {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    (context),
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatScreen(
                                                                roomId)));
                                              } else {
                                                _showToast(
                                                    "no such Room id, Please try again");
                                              }
                                            },
                                          )
                                        ],
                                      ));
                            }),
                      ],
                    ));
          },
        ),
      ),
    );
  }
}
