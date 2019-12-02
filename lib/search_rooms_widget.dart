import 'package:flutter/material.dart';

class SearchRooms extends StatefulWidget {
  final List roomsList;

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
    widget.roomsList.sort();
    List copyListForSearch = List.from(widget.roomsList.toList()); 
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: roomSearchController,
          decoration: InputDecoration(hintText: 'Enter Room Name'),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.roomsList
            .where((x) => x.contains(roomSearchController.text))
            .toList()
            .length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.roomsList
                .where((x) => x.contains(roomSearchController.text))
                .toList()[index]),
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
