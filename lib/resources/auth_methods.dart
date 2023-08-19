import 'package:firebase_auth/firebase_auth.dart';
import 'package:samvaad/screens/login_screen.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Other methods in AuthMethods...

  Future<FirebaseUser?> getCurrentUser() async {
    try {
      FirebaseUser user = _auth.currentUser as FirebaseUser;
      return user;
    } catch (e) {
      print("Error getting current user: $e");
      return null;
    }
  }

  // Other methods in AuthMethods...
}
