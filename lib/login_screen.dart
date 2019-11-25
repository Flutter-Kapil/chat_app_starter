import 'package:chat_app_starter/google_signIn.dart';
import 'package:chat_app_starter/user_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn();
  //-----------
  UserDetails loggedInUser = UserDetails();
  FirebaseUser user;
  //------------------------
  Future<FirebaseUser> signIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    // FirebaseUser userDeatils= await firebaseAuth.signInWithCredential(credential);

    // ProviderDetails providerInfo = ProviderDetails(userDetail.providerId);
  }

  bool _saving = false;
  String userEmail;
  String userPassword;
  @override
  Widget build(BuildContext context) {
    final _showToast =
        (x) => Fluttertoast.showToast(msg: x, toastLength: Toast.LENGTH_SHORT);

    var loginButtonAction = () async {
      try {
        _saving = true;
        setState(() {});
        firebaseAuth.signInWithEmailAndPassword(
            email: userEmail, password: userPassword);
        // print(result.user.email == userEmail);//#debug statement
        setState(() {
          _saving = false;
        });
        Navigator.of(context)
            .pushNamedAndRemoveUntil('rooms', (Route<dynamic> route) => false);
      } catch (e) {
        setState(() {
          _saving = false;
        });
        _showToast(e.message);
      }
    };

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
                        onEditingComplete: loginButtonAction,
                        onSubmitted: (value) {
                          loginButtonAction();
                        },
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
                    Row(
                      children: <Widget>[
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
                          onPressed: loginButtonAction,
                        ),
                        IconButton(
                          onPressed: () {
                            try {
                              signInWithGoogle().whenComplete(() {
                                print('logged in ${loggedInUser.name}');
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'rooms', (Route<dynamic> route) => false);
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          icon: Icon(Icons.group_add),
                        ),
                        IconButton(
                          onPressed: () {
                            // print(user.email);
                            print(loggedInUser.photoUrl);
                            setState(() {});
                          },
                          icon: Icon(Icons.theaters),
                        )
                      ],
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
