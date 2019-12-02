import 'package:chat_app_starter/chat_screen.dart';
import 'package:chat_app_starter/search_rooms_widget.dart';
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
  List roomsIDlist = [];
  List<List<String>> roomsNamelist = [];
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
    roomsIDlist = [];
    roomsNamelist = [];
    QuerySnapshot rooms =
        await Firestore.instance.collection('rooms').getDocuments();
    rooms.documents.forEach((document) => roomsIDlist.add(document.documentID));

    rooms.documents.forEach((document) {
      roomsNamelist.add([document['name'], document.documentID]);
    });

    // print(roomsNamelist);
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
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () async {
                await getRoomsList();
                print(roomsIDlist);
                Navigator.push(
                    (context),
                    MaterialPageRoute(
                        builder: (context) => SearchRooms(roomsNamelist)));
              },
            ),
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
          stream: Firestore.instance
              .collection('rooms')
              .orderBy('name')
              .snapshots(),
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
          tooltip: 'Create New Room',
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text('Enter New Room Name'),
                      content: TextField(
                        showCursor: true,
                        controller: roomNameController,
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('OK'),
                          onPressed: () async {
                            String tempRoomName = roomNameController.text;
                            print('tempRoomName:$tempRoomName');
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
                            getRoomsList();
                            Navigator.pushReplacement(
                                (context),
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(roomId)));
                          },
                        )
                      ],
                    ));
          },
        ),
      ),
    );
  }
}
