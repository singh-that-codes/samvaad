import 'package:flutter/material.dart';
import 'package:samvaad/constants/strings.dart';
import 'package:samvaad/models/call.dart';
import 'package:samvaad/models/log.dart';
import 'package:samvaad/resources/call_methods.dart';
import 'package:samvaad/resources/local_db/repository/log_repository.dart';
import 'package:samvaad/screens/callscreens/call_screen.dart';
import 'package:samvaad/screens/callscreens/voice_call_screen.dart';
import 'package:samvaad/screens/chatscreens/widgets/cached_image.dart';
import 'package:samvaad/utils/permissions.dart';

class PickupScreen extends StatefulWidget {
  final Call call;

  PickupScreen({
    required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();
  //final LogRepository logRepository = LogRepository(isHive: true);
 final LogRepository logRepository = LogRepository(isHive: true); // or isHive: false

  bool isCallMissed = true;

  addToLocalStorage({required String callStatus}) async {
    Log log = Log(
      callerName: widget.call.callerName,
      callerPic: widget.call.callerPic,
      receiverName: widget.call.receiverName,
      receiverPic: widget.call.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
      logId: 0, // You might need to set this value accordingly
    );

    await LogRepository.addLogs(log); // Await the method call here
  }

  @override
  void dispose() async {
    if (isCallMissed) {
      await addToLocalStorage(callStatus: CALL_STATUS_MISSED); // Await the method call here
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
                Icon(Icons.video_call_sharp, size: 50),
                Text(
                  " Video call Incoming...",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            CachedImage(
              widget.call.callerPic,
              isRound: true,
              radius: 180,
              height: 180,
              width: 180,
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
                    await addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    await callMethods.endCall(call: widget.call);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    isCallMissed = false;
                    await addToLocalStorage(callStatus: CALL_STATUS_RECEIVED);
                    if (await Permissions.cameraAndMicrophonePermissionsGranted()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreen(call: widget.call),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
