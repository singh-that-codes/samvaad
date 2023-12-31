//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:samvaad/models/user.dart';
//import 'package:samvaad/resources/auth_methods.dart';
import 'package:samvaad/screens/callscreens/pickup/pickup_layout.dart';
import 'package:samvaad/screens/chatscreens/chat_screen.dart';
import 'package:samvaad/screens/chatscreens/widgets/cached_image.dart';
import 'package:samvaad/utils/universal_variables.dart';
import 'package:samvaad/utils/utilities.dart';
import 'package:samvaad/widgets/custom_tile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthMethods _authMethods = AuthMethods();

  late List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
  super.initState();

  _authMethods.getCurrentUser().then((firebase_auth.User user) {
    _authMethods.fetchAllUsers(user).then((List<User> list) {
      setState(() {
        userList = list;
      });
    });
  });
}


  searchAppBar(BuildContext context) {
    return NewGradientAppBar(
      gradient: LinearGradient(
        colors: [
          UniversalVariables.newgradientColorStart,
          UniversalVariables.newgradientColorEnd,
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        // ignore: unnecessary_null_comparison
        : userList != null
            ? userList.where((User user) {
                String _getUsername = user.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.name.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);

                return (matchesUsername || matchesName);
              }).toList()
            : [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username, email: '', status: '', state: 0, password: '');

        
    return CustomTile(
      mini: false,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: searchedUser,
            ),
          ),
        );
      },
      leading: CachedImage(
        searchedUser.profilePhoto,
        radius: 25,
        isRound: true, height: 30,width: 30,
      ),
      title: Text(
        searchedUser.username,
        style: TextStyle(
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        searchedUser.name,
        style: TextStyle(color: UniversalVariables.greyColor),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.message,
          color: UniversalVariables.greyColor,
        ),
        onPressed: () {
          // Implement your logic for opening the chat screen here
        },
      ), icon: Icon(Icons.abc_outlined), onLongPress: () {  }, 
    );
  }),
);

  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.white,
        appBar: searchAppBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: buildSuggestions(query),
        ),
      ),
    );
  }
}
