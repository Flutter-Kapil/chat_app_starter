import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

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
        color: sender == currentUserEmail ? Colors.blue : Colors.yellow,
      ));
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
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: chatWidgets,
                )),
            Expanded(
              flex: 1,
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
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
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
                  ),
                ],
              ),
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

  chatBubble({this.text, this.sender, this.color});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          sender,
          style: TextStyle(color: Colors.grey),
        ),
        Container(
          padding: EdgeInsets.only(right: 8),
//          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(top: 6, bottom: 6),
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              )),
          child: Text(
            text,
            style: TextStyle(fontSize: 19),
          ),
        ),
      ],
    );
  }
}
