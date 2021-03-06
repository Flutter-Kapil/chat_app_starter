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

  int numberOfTrue(List listOfBools) {
    int count = 0;
    for (int i = 0; i < listOfBools.length; i++) {
      if (listOfBools[i]) {
        count++;
      }
    }
    return count;
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
//  QuickReplies quickReply;
  List<String> options;
  @override
  void initState() {
//    myController.addListener(() {
//      setState(() {});
//    });
    getCurrentUser();
    getRoomName(widget.roomId);
    getMessage();
//    quickReply = QuickReplies(
//      ValueKey(repliesList),
//      replies: repliesList,
//      selectedRepliesTextController: myController,
//      notifyParent: refresh,
//    );
    super.initState();
    _register();
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
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                print(' value of repliesVisibilty $repliesVisibility ');

                setState(() {
                  repliesVisibility = !repliesVisibility;
                });
              },
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text('Show Food Menu'),
                    value: ['Biryani', 'Khichdi', 'Sabzi', 'Pulav'],
                  ),
                  PopupMenuItem(
                    child: Text('Show Weekdays'),
                    value: [
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                      'Sunday'
                    ],
                  ),
                  PopupMenuItem(
                    child: Text('Close All'),
                    value: <String>[],
                  )
                ];
              },
              onSelected: (List<String> value) {
                print(' value of repliesVisibilty $repliesVisibility ');

                setState(() {
                  repliesVisibility = !repliesVisibility;
                });
                print('Selected value $value');
                setState(() {
                  FocusScope.of(context).unfocus();
                  options = value.isEmpty ? null : value;
//                  optionsWidget = QuickReplies(
//                    ValueKey(options),
//                    replies: options,
//                    selectedRepliesTextController: myController,
//                    notifyParent: refresh,
//                  );
                });
              },
            )
          ],
        ),
        body: Column(
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
                    onChanged: (value) {
                      setState(() {});
                    },
                    autocorrect: true,
                    autofocus: false,
                    showCursor: true,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  disabledColor: Colors.grey,
                  color: Colors.blue,
                  onPressed: (QuickReplies(
                            ValueKey(options),
                            replies: options,
                            selectedRepliesTextController: myController,
                            notifyParent: refresh,
                          ).selectedReplies.length >
                          3)
                      ? null
                      : () {
                          print(
                              'value of controller is ${myController.text.isEmpty}');

                          myController.text.isNotEmpty ? sendMessage() : null;
                        },
                ),
              ],
            ),
            if (options != null)
              Container(
                child: QuickReplies(
                  ValueKey(options),
                  replies: options,
                  selectedRepliesTextController: myController,
                  notifyParent: refresh,
                ),
              ),
          ],
        ),
      ),
    );
  }

  refresh() {
    setState(() {});
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
