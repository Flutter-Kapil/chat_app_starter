import 'package:flutter/material.dart';

class QuickReplies extends StatefulWidget {
  List<String> replies;
  bool showReplies = false;
  QuickReplies({this.replies, this.showReplies});
  @override
  _QuickRepliesState createState() => _QuickRepliesState();
}

class _QuickRepliesState extends State<QuickReplies> {
  List<bool> selectedReplies;

  @override
  void initState() {
    selectedReplies = List.generate(widget.replies.length, (i) => false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Visibility(
        visible: widget.showReplies,
        child: ListView.builder(
          itemCount: widget.replies.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomCheckBox(widget.replies, selectedReplies, index);
          },
        ),
      ),
    );
  }
}

class CustomCheckBox extends StatefulWidget {
  int index;
  List<String> weekDays;
  List<bool> weekDaysBool;
  CustomCheckBox(this.weekDays, this.weekDaysBool, this.index);
  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: widget.weekDaysBool[widget.index],
      title: Text(widget.weekDays[widget.index]),
      onChanged: (newValue) {
        widget.weekDaysBool[widget.index] = newValue;
        String selectedDays = '';
        setState(() {});
        for (int i = 0; i < 7; i++) {
          if (widget.weekDaysBool[i]) {
            selectedDays = selectedDays + widget.weekDays[i] + ',';
          }
        }
        print(selectedDays);
      },
    );
  }
}
