import 'package:flutter/material.dart';

class QuickReplies extends StatefulWidget {
  List<String> replies;
  List<String> selectedReplies;
  TextEditingController selectedRepliesTextController;
  List<bool> repliesBool;

  QuickReplies(
      {List<String> replies,
      TextEditingController selectedRepliesTextController}) {
    this.replies = replies;
    this.selectedRepliesTextController = selectedRepliesTextController;
    this.selectedReplies=[];
    this.repliesBool= List.generate(replies.length, (i) => false);
  }
  @override
  _QuickRepliesState createState() => _QuickRepliesState();
}

class _QuickRepliesState extends State<QuickReplies> {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: widget.replies.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            value: widget.repliesBool[index],
            title: Text(widget.replies[index]),
            onChanged: (newValue) {
              widget.repliesBool[index] = newValue;

              setState(() {});
              widget.selectedReplies = [];
              //----------------
              for (int i = 0; i < 7; i++) {
                if (widget.repliesBool[i]) {
                  widget.selectedReplies.add(widget.replies[i]);
                }
              }

              //---------------------
              widget.selectedRepliesTextController.text =
                  widget.selectedReplies.join(',');

              setState(() {});
              print(
                  'selected repliesText editing controller value is  :${widget.selectedReplies.join(',')}');
              print(
                  'selected replies in quick replies is :${widget.selectedReplies}');
            },
          );
        },
      ),
    );
  }
}
