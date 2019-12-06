import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'google_signIn.dart';
import 'package:fit_kit/fit_kit.dart';

void main() {
  runApp(
    MaterialApp(
      darkTheme:
          ThemeData(primaryColor: Colors.blueGrey, canvasColor: Colors.white30),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
      },
    ),
  );
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}
void read() async {
  final results = await FitKit.read(
    DataType.HEIGHT,
    dateFrom: DateTime.now().subtract(Duration(days: 5)),
    dateTo: DateTime.now(),
  );
}

void readLast() async {
  final result = await FitKit.readLast(DataType.HEIGHT);
}

void readAll() async {
  if (await FitKit.requestPermissions(DataType.values)) {
    for (DataType type in DataType.values) {
      final results = await FitKit.read(
        type,
        dateFrom: DateTime.now().subtract(Duration(days: 1)),
        dateTo: DateTime.now(),
      );
      print('fetched Data');
      results.forEach((item){
        print(item);
      });
    }
  }
}
class _WelcomeScreenState extends State<WelcomeScreen> {

  void getStepsCountForLast24Hours() async{
    List<FitData> stepsCountFitDataList = await FitKit.read(DataType.STEP_COUNT, dateFrom: DateTime.now().subtract(Duration(hours: 24)),dateTo: DateTime.now());
    stepsCountFitDataList.forEach((fitData){
      print('Total Steps count: ${fitData.value} ,userEntered Steps Count: ${fitData.value}, dateFrom: ${fitData.dateFrom},, dateTo: ${fitData.dateTo} ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text(' Log in to FitBit'),
            onPressed: () {},
          ),
          RaisedButton(
            child: Text(' Log out'),
            onPressed: () {
              FitKit.revokePermissions();
            },
          ),
          RaisedButton(
            child: Text(' Get Data'),
            onPressed: () async{
              print(DateTime.now().toIso8601String());//request permission for steps count
              bool permissionGranted = await FitKit.requestPermissions([DataType.STEP_COUNT],);
              print('permission granted status:$permissionGranted');
              //get step count
              getStepsCountForLast24Hours();
            },
          ),
        ],
      ),
    ));
  }
}
