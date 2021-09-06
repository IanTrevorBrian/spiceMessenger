import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:spicy_chat/components/rounded_button.dart';
import 'package:spicy_chat/constants.dart';



class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen'; //static modifies the var so as it is associated with the class
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Spice Chat',
                      textStyle: colorizeTextStyle1,
                      colors: colorizeColors,
                    ),
                    // WavyAnimatedText(
                    //   'Be awesome',
                    //   textStyle: TextStyle(
                    //     color: Colors.green,
                    //     fontSize: 35.0,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // WavyAnimatedText(
                    //   'Believe in better',
                    //   textStyle: TextStyle(
                    //     color: Colors.red,
                    //     fontSize: 30.0,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // WavyAnimatedText(
                    //   'Have it your way',
                    //   textStyle: TextStyle(
                    //     color: Colors.purple,
                    //     fontSize: 30.0,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              ),
            RoundedButton(title: 'Register',
              color: Colors.green,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

