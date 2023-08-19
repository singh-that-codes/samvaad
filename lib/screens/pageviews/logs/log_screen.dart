import 'package:flutter/material.dart';
import 'package:samvaad/screens/callscreens/pickup/pickup_layout.dart';
//import 'package:samvaad/screens/pageviews/logs/widgets/floating_column.dart';
//import 'package:samvaad/utils/universal_variables.dart';
import 'package:samvaad/widgets/skype_appbar.dart';

import 'widgets/log_list_container.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
        appBar: SkypeAppBar(
          key: Key('your_unique_key_here'), // Add your unique key here
          title: "Calls",
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        // floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}
