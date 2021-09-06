import 'package:flutter/material.dart';
import 'package:spicy_chat/screens/chat_screen.dart';
import 'package:spicy_chat/screens/login_screen.dart';
import 'package:spicy_chat/screens/registration_screen.dart';
import 'screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// void main() => runApp(SpicyMessenger()); //due to firebase updated info, i've had to deviate from the normal code to the one below
    Future main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      runApp(SpicyMessenger());
    }


class SpicyMessenger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black54),
      ),),
      // home: WelcomeScreen(), //replaced with initialRoute
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}



// the copy.wth() property in this case means that make all screen dark mode(hence it should come with all flutter dark mode properties) BUT only make exceptions with the body text style, which we'll ma ke it custom.