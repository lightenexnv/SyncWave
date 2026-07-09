import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/snackbarPopup.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signup(String email, String password) async {
    try{
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password);
    }
    on FirebaseAuthException catch(e){
      SnackbarUtils.show("Account Not Created", "Check Credentials");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      SnackbarUtils.show("Login Failed", "Check email and password");
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      SnackbarUtils.show("Password Reset", "Email sent to $email");
    } on FirebaseAuthException catch (e) {
      SnackbarUtils.show("Error","Failed to send reset email");
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      Get.deleteAll();
      Get.offAllNamed("/login");

      SnackbarUtils.show("Logged Out", "Successfully");
    } catch (e) {
      SnackbarUtils.show("Logout Failed", "Try again");
    }
  }
}