import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:samvaad/models/message.dart';
import 'package:samvaad/models/user.dart';
import 'package:samvaad/provider/image_upload_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samvaad/resources/chat_methods.dart';

class StorageMethods {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late Reference _storageReference; // Change this to Reference

  // user class
  User user = User(
    uid: '',
    email: '',
    password: '',
    name: '',
    username: '',
    status: '',
    state: 0,
    profilePhoto: '',
  );

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      _storageReference = FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      UploadTask storageUploadTask = _storageReference.putFile(imageFile); // Change this to UploadTask
      var url = await (await storageUploadTask).ref.getDownloadURL(); // Change this line
      return url;
    } catch (e) {
      return null;
    }
  }

  void uploadImage({
    required File image,
    required String receiverId,
    required String senderId,
    required ImageUploadProvider imageUploadProvider,
    required String type1,
    required String name,
  }) async {
    final ChatMethods chatMethods = ChatMethods();

    // Set some loading value to db and show it to the user
    imageUploadProvider.setToLoading();

    // Get URL from the image bucket
    String? url = await uploadImageToStorage(image);

    // Hide loading
    imageUploadProvider.setToIdle();

    // Provide the missing argument 'message'
    chatMethods.setImageMsg(
      customMessage: 'Image Message', // Provide your custom message here
      url: url,
      receiverId: receiverId,
      senderId: senderId,
      type1: type1,
      name: name,
    );
  }
}
