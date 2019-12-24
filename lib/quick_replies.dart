import 'package:flutter/material.dart';

class QuickReplies extends StatefulWidget {
  List<String> replies;
  List<String> selectedReplies;
  bool showReplies = false;
  bool sendButtonBool;
  TextEditingController selectedRepliesTextController;
  QuickReplies({this.replies, this.showReplies, this.selectedRepliesTextController, this.selectedReplies,this.sendButtonBool});
  @override
  _QuickRepliesState createState() => _QuickRepliesState();
}

class _QuickRepliesState extends State<QuickReplies> {
  List<bool> repliesBools;

  @override
  void initState() {
//    widget.selectedReplies=[];
    repliesBools = List.generate(widget.replies.length, (i) => false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.showReplies,
      child: Container(
        height: 200,
        child: ListView.builder(
          itemCount: widget.replies.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              value: repliesBools[index],
              title: Text(widget.replies[index]),
              onChanged: (newValue) {
                repliesBools[index] = newValue;

                setState(() {});
                widget.selectedReplies=[];
                //----------------
                for (int i = 0; i < 7; i++) {
                  if (repliesBools[i]) {
                    widget.selectedReplies.add(widget.replies[i]);
                  }
                }

                //---------------------
                widget.selectedRepliesTextController.text = widget.selectedReplies.join(',') ;

                //-----------------
                if(widget.selectedReplies.length>3){
                  widget.sendButtonBool =true;
                  setState(() {

                  });
                }else{
                  widget.sendButtonBool =false;
                  setState(() {

                  });
                }
                setState(() {

                });
                print(
                    'selected repliesText editing controller value is  :${widget.selectedReplies.join(',')}');
                print('selected replies in quick replies is :${widget.selectedReplies}');
              },
            );
          },
        ),
      ),
    );
  }
}
