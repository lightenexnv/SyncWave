import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import '../utils/snackbarPopup.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signup(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("FIREBASE SIGNUP EXCEPTION: ${e.code} - ${e.message}");
      String errorMessage = "Check Credentials";
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email already has an account";
      } else if (e.code == 'weak-password') {
        errorMessage = "Password is too weak";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address";
      }
      SnackbarUtils.show("Signup Failed", errorMessage);
      return null;
    } catch (e) {
      print("SIGNUP UNEXPECTED EXCEPTION: $e");
      SnackbarUtils.show("Signup Failed", "An unexpected error occurred: $e");
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
      print("FIREBASE LOGIN EXCEPTION: ${e.code} - ${e.message}");
      SnackbarUtils.show("Login Failed", e.message ?? "Check email and password");
      return null;
    } catch (e) {
      print("LOGIN UNEXPECTED EXCEPTION: $e");
      SnackbarUtils.show("Login Failed", "An unexpected error occurred: $e");
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      SnackbarUtils.show("Password Reset", "Email sent to $email");
    } on FirebaseAuthException catch (e) {
      print("FIREBASE PASSWORD RESET EXCEPTION: ${e.code} - ${e.message}");
      SnackbarUtils.show("Error", e.message ?? "Failed to send reset email");
    } catch (e) {
      print("PASSWORD RESET UNEXPECTED EXCEPTION: $e");
      SnackbarUtils.show("Error", "Failed to send reset email: $e");
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      Get.deleteAll();
      Get.offAllNamed("/login");
      SnackbarUtils.show("Logged Out", "Successfully");
    } catch (e) {
      print("LOGOUT EXCEPTION: $e");
      SnackbarUtils.show("Logout Failed", "Try again");
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("GOOGLE SIGN-IN: googleUser is null (user cancelled sign in)");
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print("GOOGLE SIGN-IN EXCEPTION: $e");
      SnackbarUtils.show("Google Login Failed", "Try Again: $e");
      return null;
    }
  }
}