import 'package:flutter/material.dart';
import 'package:samvaad/constants/strings.dart';
import 'package:samvaad/models/log.dart';
import 'package:samvaad/resources/local_db/repository/log_repository.dart';
import 'package:samvaad/screens/chatscreens/widgets/cached_image.dart';
import 'package:samvaad/screens/pageviews/chats/widgets/quiet_box.dart';
import 'package:samvaad/utils/utilities.dart';
import 'package:samvaad/widgets/custom_tile.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  getIcon(String callStatus) {
    Icon _icon;
    double _iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_DIALLED:
        _icon = Icon(
          Icons.call_made,
          size: _iconSize,
          color: Colors.green,
        );
        break;

      case CALL_STATUS_MISSED:
        _icon = Icon(
          Icons.call_missed,
          color: Colors.red,
          size: _iconSize,
        );
        break;

      default:
        _icon = Icon(
          Icons.call_received,
          size: _iconSize,
          color: Colors.grey,
        );
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Log>>(
      future: LogRepository.getLogs(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          List<Log> logList = snapshot.data!;

          if (logList.isNotEmpty) {
            return ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, i) {
                Log _log = logList[i];
                bool hasDialled = _log.callStatus == CALL_STATUS_DIALLED;

                return CustomTile(
                  leading: CachedImage(
                    hasDialled ? _log.receiverPic : _log.callerPic,
                    isRound: true,
                    radius: 45, height: 45,width: 45,
                  ),
                  mini: false,
                  trailing: TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete this Log?"),
                          content: Text("Are you sure you wish to delete this log?"),
                          actions: [
                            TextButton(
                              child: Text("YES"),
                              onPressed: () async {
                                Navigator.maybePop(context);
                                await LogRepository.deleteLogs(i);
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                            ),
                            TextButton(
                              child: Text("NO"),
                              onPressed: () => Navigator.maybePop(context),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(Icons.delete),
                  ),
                  title: Text(
                    hasDialled ? _log.receiverName : _log.callerName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  icon: getIcon(_log.callStatus),
                  subtitle: Text(
                    Utils.formatDateString(_log.timestamp),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ), onTap: () {  }, onLongPress: () {  },
                );
              },
            );
          }
          return QuietBox(
            heading: "",
            subtitle: "Calling people all over the world with just one click",
          );
        }

        return QuietBox(
          heading: "",
          subtitle: "Calling people all over the world with just one click",
        );
      },
    );
  }
}
