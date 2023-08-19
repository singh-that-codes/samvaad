import 'package:flutter/material.dart';
import 'package:samvaad/constants/strings.dart';
import 'package:samvaad/models/call.dart';
import 'package:samvaad/models/log.dart';

import 'package:samvaad/resources/call_methods.dart';
import 'package:samvaad/resources/local_db/repository/log_repository.dart';
import 'package:samvaad/screens/callscreens/call_screen.dart';
import 'package:samvaad/screens/callscreens/reciever_voice_call_screen.dart';
import 'package:samvaad/screens/chatscreens/widgets/cached_image.dart';
import 'package:samvaad/utils/permissions.dart';

class VoicePickupScreen extends StatefulWidget {
  final Call call;
  final Call sendername;


  VoicePickupScreen({
    required this.call,
    required this.sendername,
  });

  @override
  _VoicePickupScreenState createState() => _VoicePickupScreenState();
}

class _VoicePickupScreenState extends State<VoicePickupScreen> {
  final CallMethods callMethods = CallMethods();
  // final LogRepository logRepository = LogRepository(isHive: true);
  // final LogRepository logRepository = LogRepository(isHive: false);

  bool isCallMissed = true;
  int x=0;
  addToLocalStorage({required String callStatus}) {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus, logId: x,
    );

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    if (isCallMissed) {
      addToLocalStorage(callStatus: CALL_STATUS_MISSED);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.phone_rounded, size:50),
                  Text(
                    " Voice call Incoming...",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),

                ]
            ),
            SizedBox(height: 50),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 180, height: 50,width: 50,
            ),
            SizedBox(height: 15),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    isCallMissed = false;
                    addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                    icon: Icon(Icons.call),
                    color: Colors.green,
                    onPressed: () async {
                      isCallMissed = false;
                      addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                      await Permissions.cameraAndMicrophonePermissionsGranted()
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecieverVoiceCallScreen(call: widget.call),
                              ),
                            )
                          : {};
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
