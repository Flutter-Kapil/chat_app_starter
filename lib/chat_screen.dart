import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  ChatScreen(this.roomId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List roomsList = [];
  FirebaseUser currentUser;
  bool isCurrentUserBool;
  final editRoomNameController = TextEditingController();
  final myController = TextEditingController();
  List<Widget> chatWidgets = [];
  String currentRoomName = '...';
  @override
  void initState() {
    myController.addListener(() {
      setState(() {});
    });
    getCurrentUser();
    getRoomName(widget.roomId);
    super.initState();
  }

  Future getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  getRoomName(String documentId) async {
    DocumentSnapshot particularDocument =
        await Firestore.instance.document('rooms/$documentId').get();
    currentRoomName = await particularDocument['name'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            currentRoomName,
            overflow: TextOverflow.visible,
            softWrap: true,
            maxLines: 2,
            style: TextStyle(fontSize: 21),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text('Edit Room Name'),
                          content: TextField(
                            showCursor: true,
                            controller: editRoomNameController,
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                String tempRoomName =
                                    editRoomNameController.text;
                                print('tempRoomName:$tempRoomName');
                                print(
                                    'roomController tetx: ${editRoomNameController.text}');
                                editRoomNameController.clear();
                                Firestore.instance
                                    .collection('rooms')
                                    .document(widget.roomId)
                                    .updateData({'name': tempRoomName});
                                Navigator.pop(context);
                                setState(() {
                                  getRoomName(widget.roomId);
                                });
                              },
                            )
                          ],
                        ));
              },
            ),
           ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('rooms')
                      .document(widget.roomId)
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, int index) {
                            return ChatBubble(
                              text: snapshot.data.documents[index].data['text'],
                              sender:
                                  snapshot.data.documents[index].data['sender'],
                              isCurrentUser: currentUser.email ==
                                  snapshot.data.documents[index].data['sender'],
                            );
                          });
                    } else if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('Select lot');
                      case ConnectionState.waiting:
                        return Text('Awaiting bids...');
                      case ConnectionState.active:
                        return Text('\$${snapshot.data}');
                      case ConnectionState.done:
                        return Text('\$${snapshot.data} (closed)');
                    }
                    return null; // unreachable
                  },
                ),
              ),
              Divider(
                color: Colors.blue,
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      expands: false,
                      controller: myController,
                      autocorrect: true,
                      autofocus: false,
                      showCursor: true,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    disabledColor: Colors.grey,
                    color: Colors.blue,
                    onPressed: myController.text.isEmpty ? null : sendMessage,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() async {
    String temp = myController.text;
    myController.clear();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String currentUserEmail = currentUser.email;
    print(currentUserEmail);
    await Firestore.instance
        .collection('rooms')
        .document(widget.roomId)
        .collection('messages')
        .add(
            {'sender': currentUserEmail, 'text': temp, 'time': DateTime.now()});
  }
}
