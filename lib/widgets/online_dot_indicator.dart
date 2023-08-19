import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samvaad/enum/user_state.dart'; // Import UserState from the correct location
import 'package:samvaad/models/user.dart';
import 'package:samvaad/resources/auth_methods.dart';
import 'package:samvaad/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({required this.uid});

  Color getColor(int state) {
    switch (Utils.numToState(state)) {
      case UserState.Offline:
        return Colors.red;
      case UserState.Online:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(uid: uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.data == null) {
            return Container(); // Return an empty container if no data
          }

          User _user = User.fromMap(snapshot.data?.data as Map<String, dynamic>);

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
              color: getColor(_user.state),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}
