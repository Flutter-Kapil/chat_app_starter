import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final myController = TextEditingController();

  @override
  void initState() {
    myController.addListener(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  void getMessages() async {
    QuerySnapshot messages =
        await Firestore.instance.collection('messages').getDocuments();
    for (int i = 0; i < messages.documents.length; i++) {
      print(messages.documents.elementAt(i).data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
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
            onPressed: () {
              getMessages();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextField(
                expands: false,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                controller: myController,
                autocorrect: false,
                autofocus: true,
                showCursor: true,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              disabledColor: Colors.grey,
              color: Colors.blue,
              onPressed: myController.text.isEmpty ? null : sendMessage,
            )
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    print(myController.text);
    await Firestore.instance
        .collection('messages')
        .add({'sender': 'kapil@gmail.com', 'text': myController.text});
    myController.clear();
  }
}
