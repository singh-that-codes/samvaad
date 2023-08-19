import 'dart:math';

import 'package:flutter/material.dart';
import 'package:samvaad/constants/strings.dart';
import 'package:samvaad/models/call.dart';
import 'package:samvaad/models/log.dart';
import 'package:samvaad/models/user.dart';
import 'package:samvaad/resources/call_methods.dart';
import 'package:samvaad/resources/local_db/repository/log_repository.dart';
import 'package:samvaad/screens/callscreens/call_screen.dart';
import 'package:samvaad/screens/callscreens/voice_call_screen.dart';

class VoiceCallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User? from, required User to, context}) async {
    Call call = Call(
      callerId: from!.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      voice: true,
      channelId: Random().nextInt(1000).toString(), hasDialled: true,
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(), logId: 0,
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      // enter log
      LogRepository.addLogs(log);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceCallScreen(call: call),
        ),
      );
    }
  }
}
