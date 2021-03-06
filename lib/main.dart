import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/rooms_page.dart';
import 'screens/search_rooms_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    MaterialApp(
      darkTheme:
          ThemeData(primaryColor: Colors.blueGrey, canvasColor: Colors.white30),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        'login': (context) => LoginScreen(),
        'register': (context) => RegisterScreen(),
//        'chat': (context) => ChatScreen(),
        'rooms': (context) => RoomsScreen(),
        'searchRooms': (context) => SearchRooms(),
      },
    ),
  );
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
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
      Navigator.pushReplacementNamed(context, 'rooms');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'LogoImage',
            child: Image(
                image:
                    NetworkImage('https://mclarencollege.in/images/icon.png'),
                width: 200,
                height: 200,
                fit: BoxFit.contain),
          ),
          Container(
            padding: EdgeInsets.all(12.0),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'McLaren Chat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 36,
                      color: Color(0xFF4790F1),
                      fontFamily: 'Poppins'),
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 21),
                  ),
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'register');
                  },
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 21),
                  ),
                  color: Colors.purple,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
