// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/models/call.dart';
import 'package:samvaad/provider/user_provider.dart';
import 'package:samvaad/resources/call_methods.dart';
import 'package:samvaad/screens/callscreens/pickup/pickup_screen.dart';
import 'package:samvaad/screens/callscreens/pickup/voice_pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (userProvider != null && userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data?.data != null) {
                Call call = Call.fromMap(snapshot.data?.data as Map<String, dynamic>);

                print("voiceeee ${call.voice}");
                if (!call.hasDialled) {
                  if (call.voice == true) {
                    return VoicePickupScreen(call: call, sendername: call.sendername);
                  } else {
                    return PickupScreen(call: call);
                  }
                }
              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
