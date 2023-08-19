import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:samvaad/models/message.dart';
import 'package:samvaad/models/user.dart';
import 'package:samvaad/provider/image_upload_provider.dart';
//import 'package:samvaad/resources/chat_methods.dart';

class StorageMethods {
  final Reference _storageReference =
      FirebaseStorage.instance.ref(); // Initialize _storageReference

  // User class instance
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
  
  String? get customMessage => null;

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      final reference = _storageReference.child('${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = reference.putFile(imageFile);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
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

    // Set loading state
    imageUploadProvider.setToLoading();

    // Upload image and get URL
    String? url = await uploadImageToStorage(image);

    // Set idle state
    imageUploadProvider.setToIdle();

    if (url != null) {
      // Call the method to send image message
      chatMethods.setImageMsg(
        customMessage: 'Image Message', // Provide your custom message here
        url: url,
        receiverId: receiverId,
        senderId: senderId,
        type1: type1,
        name: name,
      );
    } else {
      print('Image upload failed');
    }
  }
}
