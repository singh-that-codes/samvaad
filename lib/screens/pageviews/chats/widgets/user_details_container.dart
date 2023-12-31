import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:samvaad/enum/user_state.dart';
import 'package:samvaad/models/user.dart';
import 'package:samvaad/provider/user_provider.dart';
//import 'package:samvaad/resources/auth_methods.dart';
import 'package:samvaad/screens/chatscreens/widgets/cached_image.dart';
import 'package:samvaad/screens/login_screen.dart';
import 'package:samvaad/utils/utilities.dart';
import 'package:samvaad/widgets/appbar.dart';

import 'shimmering_logo.dart';

class UserDetailsContainer extends StatelessWidget {
  final AuthMethods authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    signOut() async {
      final bool isLoggedOut = await AuthMethods().signOut();
      if (isLoggedOut) {
        // set userState to offline as the user logs out'
        authMethods.setUserState(
          userId: userProvider.getUser.uid,
          userState: UserState.Offline,
        );

        // move the user to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
  key: Key("your_custom_app_bar_key"), // Replace with your desired key value
  leading: IconButton(
    icon: Icon(
      Icons.arrow_back,
      color: Colors.white,
    ),
    onPressed: () => Navigator.maybePop(context),
  ),
  centerTitle: true,
  title: ShimmeringLogo(),
  actions: <Widget>[
    ElevatedButton(
      onPressed: () => signOut(),
      child: Text(
        "Sign Out",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
  ],
),

          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final User user = userProvider.getUser;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user.profilePhoto,
            isRound: true,
            radius: 50, height: 20,width: 20,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user.email,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
