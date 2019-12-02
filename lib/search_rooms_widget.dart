import 'package:flutter/material.dart';

import 'chat_screen.dart';

class SearchRooms extends StatefulWidget {
  final List<List<String>> roomsList;

  SearchRooms([this.roomsList]);
  @override
  _SearchRoomsState createState() => _SearchRoomsState();
}

class _SearchRoomsState extends State<SearchRooms> {
  final roomSearchController = TextEditingController();

  @override
  void initState() {
    roomSearchController.addListener(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.roomsList.sort((subList)=>subList[0]);
    widget.roomsList.sort((a, b) => a[0].compareTo(b[0]));
    // List copyListForSearch = List.from(widget.roomsList.toList());
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          showCursor: true,
          controller: roomSearchController,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.black,
          decoration: InputDecoration(hintText: 'Enter Room Name',hintStyle: TextStyle(color: Colors.white)),
          textInputAction: TextInputAction.search,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.roomsList
            .where((x) =>
                x[0].contains(roomSearchController.text.toUpperCase()) ||
                x[0].contains(roomSearchController.text.toLowerCase()))
            .toList()
            .length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.roomsList
                .where((x) =>
                    x[0].contains(roomSearchController.text.toUpperCase()) ||
                    x[0].contains(roomSearchController.text.toLowerCase()))
                .toList()[index][0]),
            onTap: () {
              print('tapped on some item');
              String roomId = widget.roomsList
                  .where((x) =>
                      x[0].contains(roomSearchController.text.toUpperCase()) ||
                      x[0].contains(roomSearchController.text.toLowerCase()))
                  .toList()[index][1];
              print('roomId:$roomId');
              Navigator.pop(context);
              Navigator.push((context),
                  MaterialPageRoute(builder: (context) => ChatScreen(roomId)));
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    roomSearchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
