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
        dateFrom: DateTime.now().subtract(Duration(days: 5)),
        dateTo: DateTime.now(),
      );
      print('fetched Data');
      print(results);
    }
  }
}
class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    isUserLoggedIn();
    // TODO: implement initState
    super.initState();
  }

  isUserLoggedIn() async {
    var x = await FirebaseAuth.instance.currentUser();
    if (x != null) {
//      Navigator.pushReplacementNamed(context, 'rooms');
    print(x.email);
    print(x.uid);
    print(x.providerId);
    }
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
              bool permissionGranted = await FitKit.requestPermissions(DataType.values);
              print('permission granted status:$permissionGranted');
              await readAll();
//              try{
//                var result = await FitKit.read(DataType.HEIGHT,dateFrom: DateTime.now().subtract(Duration(days: 5)),
//                  dateTo: DateTime.now());
//                print(result);
//              }catch(e){
//                print('error:$e');
//              }
            },
          ),
        ],
      ),
    ));
  }
}
