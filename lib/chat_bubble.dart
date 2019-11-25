import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final ShapeBorder shapeMe = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0)));

  final ShapeBorder shapeOthers = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
          topRight: Radius.circular(15.0)));
  final String text;
  final String sender;
  final bool isCurrentUser;
  ChatBubble({this.text, this.sender, this.isCurrentUser});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
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
                  padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: Text(
                      text,
//                          textAlign: TextAlign.start,
                      style: TextStyle(
                        color: isCurrentUser ? Colors.white : Colors.black,
                        fontSize: 18,
                      ),
                      softWrap: true,
                    ),
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
