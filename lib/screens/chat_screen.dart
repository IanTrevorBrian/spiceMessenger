import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:spicy_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
User loggedInUser; //due to the evolving of code, we can no longer user Firebase as a datatype, but we can only term it as User


class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;//saves the message that user has typed

  @override
  void initState() { //triggers the getCurrentUser mtd
    super.initState();

    getCurrentUser();
  }

  //method to check if there is a current user who's signed in
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser; //this is null IF no user signs in but corresponds to user that signs in and it helps us tap in to the user's email or password
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e){
      print(e);
    }
  }

  //mtd that takes no inputs but is also an async mtd used to listen to stream of messages coming over from firebase
  // void messagesStream() async {
  //    await for(var snapshot in _fireStore.collection('messages').snapshots())  {
  //      for (var message in snapshot.docs) {
  //        print(message.data());
  //      }
  //   }
  // }
    //_fireStore.collection('messages').snapshots() --> returns stream of query snapshots //list of futures

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: AnimatedTextKit(
            animatedTexts: [
            ColorizeAnimatedText(
               'SpicyMessenger',
                textStyle: colorizeTextStyle,
                colors: colorizeColors,
            ),
        ],
          isRepeatingAnimation: true,
          repeatForever: true,
              )
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();//helps in clearing message in message board after hitting send
                      _fireStore.collection('messages').add({'text':messageText,'sender':loggedInUser.email,'time':Timestamp.now(),});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>( //stream builder handles a stream and creates and updates list of text widget everytime a new chat message comes into a stream
      stream: _fireStore.collection('messages').orderBy('time', descending: true).snapshots(),
      builder: (context, snapshot){
        List<MessageBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightGreenAccent,
            ),
          );
        }
        final messages = snapshot.data.docs; //how to access our data inside the async snapshot //

        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];
          final Timestamp messageTime = message['time'] as Timestamp;

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(text: messageText,sender: messageSender,isMe: currentUser == messageSender, time: messageTime,);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true, //when set to true, listview sticks to the bottom of the view thus enabling bottom of listview to always show
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
            children: messageBubbles,
          ),
        );

      },
    );
  }
}


//class to contain messages wrapped inside bubble
class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.time});

  final String sender;
  final String text;
  final bool isMe;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, //pushes the bubbles to furthest(one side) end of the right
        children: [
          Text(sender, style: TextStyle(fontSize: 10.0,color: isMe ? Colors.purple : Colors.green),),
          Material(
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)) : BorderRadius.only(topRight: Radius.circular(30.0),bottomRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.purple : Colors.green,  //this is so as to differentiate user bubbles depending on who sent the message
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Text(text, style: TextStyle(fontSize: 17 ,color: Colors.black,),),
              )
          ),
        ],
      ),
    );
  }
}


// N/B when using _auth.currentUser(), i got an error of The expression doesn't evaluate to a function, so it can't be invoked...This is because i was using an old tutorial...currentUser is no longer a method but is now a property...There is no longer need to await it so
//StreamBuilder --> turns snapshots of data into actual widgets everytime new data comes thro //rebuilds everytime that there's new data coming from the screen and does that using setState()