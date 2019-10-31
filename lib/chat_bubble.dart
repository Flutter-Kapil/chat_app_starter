import 'package:flutter/material.dart';

class chatBubble extends StatelessWidget {
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
