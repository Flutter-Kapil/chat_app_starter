import 'package:flutter/material.dart';

class QuickReplies extends StatefulWidget {
  List<String> replies;
  List<String> selectedReplies;
  TextEditingController selectedRepliesTextController;
  Function() notifyParent;
//  QuickReplies({Key key}) : super(key: key));
  QuickReplies(
      Key key,
      {List<String> replies,
      TextEditingController selectedRepliesTextController,
      Function() notifyParent}):super(key:key) {

    this.notifyParent = notifyParent;
    this.replies = replies;
    this.selectedRepliesTextController = selectedRepliesTextController;
    this.selectedReplies = [];
  }
  @override
  _QuickRepliesState createState() => _QuickRepliesState();
}

class _QuickRepliesState extends State<QuickReplies> {

  List repliesBool;

  @override
  void initState() {
    print('init state called in qucikReply');
//    widget.notifyParent();
    repliesBool = List.generate(widget.replies.length, (i) => false);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: widget.replies.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            value: repliesBool[index],
            title: Text(widget.replies[index]),
            onChanged: (newValue) {
              print('onChanged widget.replies[index]:${widget.replies[index]} repliesBool[index]:${repliesBool[index]}');
              repliesBool[index] = newValue;

              setState(() {});
              widget.selectedReplies = [];
              //----------------
              for (int i = 0; i < widget.replies.length; i++) {
                if (repliesBool[i]) {
                  widget.selectedReplies.add(widget.replies[i]);
                }
              }

              //---------------------
              widget.selectedRepliesTextController.text =
                  widget.selectedReplies.join(',');

              setState(() {});
              widget.notifyParent();
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

  @override
  void dispose() {
    print('dispose called in qucikReply');
    // TODO: implement dispose
    super.dispose();
  }
}
