import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:samvaad/constants/strings.dart';
import 'package:samvaad/enum/user_state.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/models/user.dart' as app_user;
import 'package:samvaad/utils/utilities.dart';

class AuthMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<User?> getCurrentUser() async {
    User? currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<app_user.User?> getUserDetails() async {
    try {
      User? currentUser = await getCurrentUser();

      if (currentUser != null) {
        DocumentSnapshot documentSnapshot =
            await _userCollection.doc(currentUser.uid).get();
        return app_user.User.fromMap(
            documentSnapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<app_user.User?> getUserDetailsById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _userCollection.doc(id).get();
      return app_user.User.fromMap(
          documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> signIn() async {
  try {
    GoogleSignInAccount? _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount!.authentication;

    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );

    UserCredential authResult = await _auth.signInWithCredential(credential);
    return authResult.user!;
  } catch (e) {
    print("Auth methods error");
    print(e);
    return null;
  }
}


  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await _firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .get();

    final List<QueryDocumentSnapshot> docs = result.docs;

    // If user is registered then length of list > 0 or else less than 0
    return docs.length == 0;
  }

  Future<void> addDataToDb(User currentUser) async {
  String? email = currentUser.email;
  String? displayName = currentUser.displayName;
  String? photoURL = currentUser.photoURL;

  if (email != null && displayName != null && photoURL != null) {
    String username = Utils.getUsername(email);

    app_user.User user = app_user.User(
      uid: currentUser.uid,
      email: email,
      name: displayName,
      profilePhoto: photoURL,
      username: username,
      status: '',
      state: 0, password: '',
    );

    await _userCollection.doc(currentUser.uid).set(user.toMap());
  } else {
    print("User data is not complete.");
  }
}


  Future<List<app_user.User>> fetchAllUsers(User currentUser) async {
    List<app_user.User> userList = [];

    QuerySnapshot querySnapshot =
        await _firestore.collection(USERS_COLLECTION).get();
    for (var document in querySnapshot.docs) {
      if (document.id != currentUser.uid) {
        userList.add(app_user.User.fromMap(document.data()
            as Map<String, dynamic>)); // You can access data using the document.data() method
      }
    }
    return userList;
  }

  Future<bool> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void setUserState({required String userId, required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUserStream({required String uid}) =>
      _userCollection.doc(uid).snapshots();
}

mixin documents {
}
