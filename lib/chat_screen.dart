import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

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
  final myController = TextEditingController();
  List<Widget> chatWidgets = [];

  @override
  void initState() {
    myController.addListener(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  Future getMessages() async {
    QuerySnapshot messages =
        await Firestore.instance.collection('messages').getDocuments();
//now lets also fetch current user email id
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String currentUserEmail = currentUser.email;
    for (DocumentSnapshot message in messages.documents) {
      String text = message.data['text'];
      String sender = message.data['sender'];
//      print('$text from $sender');
      chatWidgets.add(chatBubble(
        text: text,
        sender: sender,
        color: sender == currentUserEmail ? Color(0xFF1E88E5) : Colors.white,
        rowAlignment: sender == currentUserEmail
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        colAlignment: sender == currentUserEmail
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        shape: sender == currentUserEmail ? shapeMe : shapeOthers,
      ));
    }
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
              await getMessages();
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
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: chatWidgets,
              ),
            )),
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
    print(myController.text);
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String currentUserEmail = currentUser.email;
    await Firestore.instance
        .collection('messages')
        .add({'sender': currentUserEmail, 'text': myController.text});
    myController.clear();
  }
}

class chatBubble extends StatelessWidget {
  String text;
  String sender;
  Color color;
  MainAxisAlignment rowAlignment;
  CrossAxisAlignment colAlignment;
  ShapeBorder shape;
  chatBubble(
      {this.text,
      this.sender,
      this.color,
      this.rowAlignment,
      this.colAlignment,
      this.shape});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: rowAlignment,
        children: <Widget>[
          Column(
            crossAxisAlignment: colAlignment,
            children: <Widget>[
              Text(
                sender,
                style: TextStyle(color: Colors.grey),
              ),
              Material(
                color: color,
                elevation: 5,
                shape: shape,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
