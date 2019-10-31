import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

ShapeBorder shapeMe = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
        topLeft: Radius.circular(15.0)));

ShapeBorder shapeOthers = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
        topRight: Radius.circular(15.0)));

class _ChatScreenState extends State<ChatScreen> {
  FirebaseUser currentUser;
  bool isCurrentUserBool;
  final myController = TextEditingController();
  List<Widget> chatWidgets = [];

  @override
  void initState() {
    myController.addListener(() {
      setState(() {});
    });
    getCurrentUser();
    super.initState();
  }

  Future getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.verified_user),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
            icon: Icon(Icons.cloud_download),
            onPressed: () async {
              chatWidgets.clear();
              setState(() {});
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
                stream: Firestore.instance.collection('messages').snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, int index) {
                          return chatBubble(
                            text: snapshot.data.documents[index].data['text'],
                            sender:
                                snapshot.data.documents[index].data['sender'],

                            //TODO: implement  isCurrentUser bool
                            isCurrentUser: currentUser.email ==
                                snapshot.data.documents[index].data['sender'],
                            color: currentUser.email ==
                                    snapshot
                                        .data.documents[index].data['sender']
                                ? Color(0xFF1E88E5)
                                : Colors.white,
                            rowAlignment: currentUser.email ==
                                    snapshot
                                        .data.documents[index].data['sender']
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            colAlignment: currentUser.email ==
                                    snapshot
                                        .data.documents[index].data['sender']
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            shape: currentUser.email ==
                                    snapshot
                                        .data.documents[index].data['sender']
                                ? shapeMe
                                : shapeOthers,
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
                    autocorrect: false,
                    autofocus: false,
                    showCursor: false,
                    textAlign: TextAlign.center,
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
    );
  }

  void sendMessage() async {
    String temp = myController.text;
    myController.clear();
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String currentUserEmail = currentUser.email;
    await Firestore.instance
        .collection('messages')
        .add({'sender': currentUserEmail, 'text': temp});
  }
}
