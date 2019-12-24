import 'package:chat_app_starter/custom%20widgets/chat_bubble.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../quick_replies.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;
  ChatScreen(this.roomId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> selectedRepliesList = [];
  List roomsList = [];
  FirebaseUser currentUser;
  bool isCurrentUserBool;
  final editRoomNameController = TextEditingController();
  final myController = TextEditingController();
  List<Widget> chatWidgets = [];
  String currentRoomName = '...';

  Future getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  getRoomName(String documentId) async {
    DocumentSnapshot particularDocument =
        await Firestore.instance.document('rooms/$documentId').get();
    currentRoomName = await particularDocument['name'];
    setState(() {});
  }

  String _message = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _register() {
    _firebaseMessaging
        .getToken()
        .then((token) => print('your token is $token'));
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      setState(() => _message = message["notification"]["title"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }

  List<String> repliesList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Frinday',
    'Saturday',
    'Sunday'
  ];
  bool repliesVisibility = false;
  bool disableButton = false;
  QuickReplies quickReply;

  @override
  void initState() {
    myController.addListener(() {
      setState(() {});
    });
    getCurrentUser();
    getRoomName(widget.roomId);
    getMessage();
    quickReply = QuickReplies(
      replies: repliesList,
      showReplies: repliesVisibility,
      selectedRepliesTextController: myController,
      selectedReplies: selectedRepliesList,
      sendButtonBool: disableButton,
    );
    super.initState();
    _register();
  }

  @override
  Widget build(BuildContext context) {
    print('hi');
    print(
        'selected replies :$selectedRepliesList and value of disabledButton is $disableButton');
    // if(selectedReplies.split(',').toList().length>3){
    //   myController.text=selectedReplies;
    // }
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
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                print(' value of quickReply.showReplies ${quickReply.showReplies} ');

                setState(() {});
                setState(() {quickReply.showReplies = !quickReply.showReplies;});
              },
            )
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
                    onPressed: (myController.text.isEmpty || quickReply.sendButtonBool)
                        ? null
                        : sendMessage,
                  ),
                ],
              ),
              Visibility(
                visible: quickReply.showReplies,
                  child: quickReply),
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
