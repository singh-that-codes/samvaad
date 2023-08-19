import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/resources/chat_methods.dart';
//import 'package:samvaad/models/message.dart';

class LastMessageContainer extends StatelessWidget {
  final stream;

  LastMessageContainer({
    @required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
  stream: stream,
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      var docList = snapshot.data?.docs; // Use 'docs' instead of 'documents'

      if (docList!.isNotEmpty) {
        Message message = Message.fromMap(docList.last.data() as Map<String, dynamic>);
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            message.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        );
      }
      return Text(
        "No Message",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      );
    }
    return Text(
      "..",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    );
  },
);

  }
}

mixin documents {
}
