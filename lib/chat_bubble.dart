import 'package:flutter/material.dart';

class chatBubble extends StatelessWidget {
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
  String text;
  String sender;
  Color color;
  MainAxisAlignment rowAlignment;
  CrossAxisAlignment colAlignment;
  ShapeBorder shape;
  bool isCurrentUser;
  chatBubble(
      {this.text,
      this.sender,
      this.color,
      this.rowAlignment,
      this.colAlignment,
      this.shape,
      this.isCurrentUser});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                sender,
                style: TextStyle(color: Colors.grey),
              ),
              Material(
                color: isCurrentUser ? Color(0xFF1E88E5) : Colors.white,
                elevation: 5,
                shape: isCurrentUser ? shapeMe : shapeOthers,
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
