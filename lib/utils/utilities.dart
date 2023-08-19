// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:samvaad/utils/utilities.dart';
import 'package:samvaad/models/user.dart';
import 'package:samvaad/screens/login_screen.dart';

enum UserState { Online, Offline, Waiting } // Move the enum here

class Utils {
  static String getUsername(String email) {
    return "samvaad:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  Future<File> pickImage({required ImageSource source}) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? selectedImage = await _imagePicker.pickImage(source: source);
    if (selectedImage != null) {
      File imageFile = File(selectedImage.path);
      return await compressImage(imageFile);
    } else {
      throw Exception("No image selected");
    }
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    // You can implement image compression logic here using different libraries

    // For now, return the original image
    return imageToCompress;
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;
      case UserState.Online:
        return 1;
      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;
      case 1:
        return UserState.Online;
      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');
    return formatter.format(dateTime);
  }
}

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({required this.uid});

  Color getColor(int state) {
    switch (Utils.numToState(state)) {
      case UserState.Offline:
        return Colors.red;
      case UserState.Online:
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(uid: uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.data == null) {
            return Container(); // Return an empty container if no data
          }

          User _user = User.fromMap(snapshot.data?.data() as Map<String, dynamic>);

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
              color: getColor(_user.state),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}

class AuthMethods {
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  // Implement your methods here
  Stream<DocumentSnapshot<Object?>> getUserStream({required String uid}) {
    return _userCollection.doc(uid).snapshots();
  }

  getUserDetails() {}

  authenticateUser(FirebaseUser user) {}

  addDataToDb(FirebaseUser user) {}

  signIn() {}

  getCurrentUser() {}

  fetchAllUsers(User user) {}

  void setUserState({required String userId, required UserState userState}) {}

  signOut() {}
}
