import 'package:chat_app_starter/register_screen.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        'login': (context) => LoginScreen(),
        'register': (context) => RegisterScreen(),
        'chat': (context) => ChatScreen(),
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
