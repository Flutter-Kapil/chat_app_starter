import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _saving = false;
  String userEmail;
  String userPassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ModalProgressHUD(
          inAsyncCall: _saving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
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
                      'Login',
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
                        userEmail = value;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        obscureText: true,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            hintText: 'spacexRocks',
                            border: OutlineInputBorder()),
                        onChanged: (value) {
                          userPassword = value;
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 21),
                      ),
                      color: Colors.blue,
                      onPressed: () async {
                        _saving = true;
                        setState(() {});
                        AuthResult result = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: userEmail, password: userPassword);
                        print(result.user.email == userEmail);
                        print('here now');
                        setState(() {
                          _saving = false;
                        });
                        Navigator.pushNamed(context, 'chat');
                      },
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
