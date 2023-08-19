import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String uid;
  Timestamp addedOn;

  Contact({
    required this.uid,
    required this.addedOn,
  });

  // Named constructor to create a Contact instance from a map
  factory Contact.fromMap(Map<String, dynamic> mapData) {
    return Contact(
      uid: mapData['contact_id'],
      addedOn: mapData['added_on'],
    );
  }

  // Method to convert a Contact instance to a map
  Map<String, dynamic> toMap() {
    return {
      'contact_id': uid,
      'added_on': addedOn,
    };
  }
}
