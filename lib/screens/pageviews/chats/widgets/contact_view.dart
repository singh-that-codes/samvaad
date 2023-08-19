import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/models/contact.dart';
import 'package:samvaad/models/message.dart';
import 'package:samvaad/models/user.dart';
import 'package:samvaad/provider/user_provider.dart';
import 'package:samvaad/resources/auth_methods.dart';
//import 'package:samvaad/resources/chat_methods.dart';
import 'package:samvaad/screens/chatscreens/chat_screen.dart';
import 'package:samvaad/screens/chatscreens/widgets/cached_image.dart';
import 'package:samvaad/screens/pageviews/chats/widgets/last_message_container.dart';
import 'package:samvaad/screens/pageviews/chats/widgets/online_dot_indicator.dart';
import 'package:samvaad/utils/utilities.dart';
import 'package:samvaad/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data!; // Use the non-nullable value

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      icon: Icon(Icons.person), // Add the appropriate icon
      trailing: Icon(Icons.arrow_forward), // Add the appropriate trailing icon
      onLongPress: () {
        // Define your onLongPress functionality here
      },
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
      title: Text(
        contact.name,
        style: TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),
      subtitle: LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true, height: 100, width: 100,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
