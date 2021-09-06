import 'package:flutter/material.dart';
import 'package:spicy_chat/components/rounded_button.dart';
import 'package:spicy_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spicy_chat/screens/login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance; //we'll use _auth object,which is a static var to authenticate users by using associated mtds like 'signInWithEmailAndPassword', 'createUserWithEmailAndPassword'
  bool showSpinner = false; //this is to prevent spinner from spinning in the beginning
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner, //starts out as being false but when user hits the onPressed it turns to true and starts spinning
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email...'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password...'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(title: 'Register',
                color: Colors.green,
                onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: email, password: password);
                  if(newUser != null){
                    Navigator.pushNamed(context, LoginScreen.id);
                  }
                  setState(() {
                    showSpinner = false; //telling spinner to stop after getting registered user
                  });
                }
                catch (e) {
                  print(e);
                }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

