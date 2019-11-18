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
    roomsList = [];
    await Firestore.instance.collection('rooms').getDocuments();
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
    final _showToast =
        (x) => Fluttertoast.showToast(msg: x, toastLength: Toast.LENGTH_SHORT);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat Rooms'),
        ),
        body: Column(
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
                                        builder: (context) => ChatScreen(
                                            snapshot.data.documents[index]
                                                .documentID)));
                              },
                              subtitle: Text(
                                snapshot.data.documents[index].documentID,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              title:
                                  snapshot.data.documents[index].data['name'] !=
                                          null
                                      ? Text(snapshot
                                          .data.documents[index].data['name'])
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
            ),
//            SizedBox(
//              height: 10,
//            ),
            Expanded(
              flex: 2,
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
                    disabledColor: Colors.blueGrey,
                    color: Colors.deepPurpleAccent,
                    textColor: Colors.white,
                    child: Text('Join Room'),
                    onPressed: roomIdController.text.isEmpty
                        ? null
                        : () async {
                            print('here now 1');
                            String tempRoomId = roomIdController.text;
                            roomIdController.clear();
                            roomId = tempRoomId;
//TODO: fix joining room
                            print('trying to join room $roomId');

                            await getRoomsList();
                            if (roomsList.contains(roomId)) {
                              Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatScreen(roomId)));
                            } else {
                              _showToast("no such Room id, Please try again");
                            }
                          },
                  ),
                ],
              ),
            ),

            // create new room button
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
//              title: Text('Join / Create Room'),
                      children: <Widget>[
                        ListTile(title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('Create Room'),
                            Spacer(),
                            Icon(Icons.add),
                          ],
                        ),
                          onTap: ()async {
                          Navigator.pop(context);
                            int randomNumber = 1111 + Random().nextInt(888);
                            roomId = randomNumber.toString();
                            if (roomsList.contains(roomId)) {
                              print("current Room Id already exits, try again");
                              _showToast("current Room Id already exits, try again");
                            } else {
                              Firestore.instance
                                  .collection('rooms')
                                  .document(roomId)
                                  .setData({
                                'roomID': roomId,
                                'time': DateTime.now(),
                                'name': roomId
                              });
                              Navigator.push(
                                  (context),
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(roomId)));
                            }
                          },
                        ),
                        ListTile(title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text('Join'),
                            Spacer(),
                            Icon(Icons.merge_type),
                          ],
                        ),),
                      ],
                    ));
//            showDialog(
//                context: context,
//                builder: (BuildContext context) => AlertDialog(
//              title: Text('Join / Create Room'),
//                  actions: <Widget>[
//                    ListTile(title: Text('Create Room'),),
//                    ListTile(title: Text('Join Room'),),
//                  ],
//
//                ));
          },
        ),
      ),
    );
  }
}
