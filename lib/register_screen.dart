import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

String email;
String password;

class _RegisterScreenState extends State<RegisterScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _saving = false;

  final _showToast =
      (x) => Fluttertoast.showToast(msg: x, toastLength: Toast.LENGTH_SHORT);
  @override
  Widget build(BuildContext context) {
    var registerButtonAction = () async {
      try {
        _saving = true;
        AuthResult result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (result.user != null) {
          firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
            setState(() {
          
        });
          Navigator.popAndPushNamed(context, 'rooms');
        }
      } catch (e) {
        _saving = false;
        _showToast(e.message);
      }
    };

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.blue),
        backgroundColor: Colors.transparent,
      ),
      body: ModalProgressHUD(
              inAsyncCall: _saving,
              child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SingleChildScrollView(
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: 'LogoImage',
                      child: Image(
                          image: NetworkImage(
                              'https://mclarencollege.in/images/icon.png'),
                          fit: BoxFit.contain),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36,
                          color: Color(0xFF4790F1),
                          fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: 'elon@musk.com',
                          icon: Icon(Icons.email),
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      onSubmitted: (password) {
                        registerButtonAction();
                      },
                      onEditingComplete: registerButtonAction,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'spacexRocks',
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      ),
                      color: Colors.purple,
                      onPressed: registerButtonAction,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
