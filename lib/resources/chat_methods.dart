import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String receiverId;
  final String senderId;
  final String type1;
  final String photoUrl;
  final String name;
  final Timestamp timestamp;
  final String messageType;
  final String imageUrl;

  Message({
    required this.message,
    required this.receiverId,
    required this.senderId,
    required this.type1,
    required this.photoUrl,
    required this.name,
    required this.timestamp,
    required this.messageType,
    required this.imageUrl,
  });

  Map<String, dynamic> toImageMap() {
    return {
      'message': message,
      'receiverId': receiverId,
      'senderId': senderId,
      'type1': type1,
      'photoUrl': photoUrl,
      'name': name,
      'timestamp': timestamp,
      'messageType': messageType,
      'imageUrl': imageUrl,
    };
  }

  factory Message.imageMessage({
    required String message,
    required String receiverId,
    required String senderId,
    required String type1,
    required String photoUrl,
    required String name,
    required Timestamp timestamp,
    required String messageType,
    required String imageUrl,
  }) {
    return Message(
      message: message,
      receiverId: receiverId,
      senderId: senderId,
      type1: type1,
      photoUrl: photoUrl,
      name: name,
      timestamp: timestamp,
      messageType: messageType,
      imageUrl: imageUrl,
    );
  }

  toMap() {}
}
