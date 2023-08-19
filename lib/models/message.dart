import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:samvaad/constants/strings.dart';
import 'package:samvaad/models/contact.dart';
//import 'package:samvaad/models/message.dart';
//import 'package:meta/meta.dart';
import 'package:samvaad/resources/chat_methods.dart';

class ChatMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _messageCollection =
      _firestore.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<DocumentReference<Map<String, dynamic>>> addMessageToDb(
      Message message) async {
    var map = message.toMap();

    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference<Map<String, dynamic>> getContactsDocument(
      {required String of, required String forContact}) =>
      _userCollection
          .doc(of)
          .collection(CONTACTS_COLLECTION)
          .doc(forContact);

  addToContacts({required String senderId, required String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    Timestamp currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      //does not exist
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap();

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    Timestamp currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      //does not exist
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap();

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  void setImageMsg(
    String customMessage,
    String url,
    String receiverId,
    String senderId,
    String type1,
    String name, 
  ) async {
    Message message = Message.imageMessage(
      message: customMessage,
      receiverId: receiverId,
      senderId: senderId,
      type1: type1,
      photoUrl: url,
      name: name,
      timestamp: Timestamp.now(),
      messageType: '',
      imageUrl: '',
    );

    // create image map
    var map = message.toImageMap();

    await _messageCollection
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);

    _messageCollection
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchContacts(
          {required String userId}) =>
      _userCollection
          .doc(userId)
          .collection(CONTACTS_COLLECTION)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchLastMessageBetween({
    required String senderId,
    required String receiverId,
  }) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}
