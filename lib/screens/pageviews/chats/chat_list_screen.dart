import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/models/contact.dart';
import 'package:samvaad/models/message.dart';
import 'package:samvaad/provider/user_provider.dart';
import 'package:samvaad/screens/callscreens/pickup/pickup_layout.dart';
import 'package:samvaad/screens/pageviews/chats/widgets/contact_view.dart';
import 'package:samvaad/screens/pageviews/chats/widgets/quiet_box.dart';
import 'package:samvaad/screens/pageviews/chats/widgets/user_circle.dart';
import 'package:samvaad/widgets/skype_appbar.dart';
//import 'package:samvaad/resources/chat_methods.dart';
//import 'widgets/new_chat_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
        appBar: SkypeAppBar(
          title: UserCircle(),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/search_screen");
              },
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ], key: Key(''),
        ),
        body: ChatListContainer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Container(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( // Change the stream type
        stream: _chatMethods.fetchContacts(
          userId: userProvider.getUser.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final contacts = snapshot.data!.docs.map((doc) {
              return Contact.fromMap(doc.data());
            }).toList();

            if (contacts.isEmpty) {
              return QuietBox(
                heading: "",
                subtitle:
                    "Search for your friends and family to start calling or chatting with them",
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return ContactView(contact);
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
