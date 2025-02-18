// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_to_do_app/home_screen.dart';
import 'package:my_to_do_app/login_page.dart';
import 'package:my_to_do_app/sign_up.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  //email, password, name...

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    //our user will be notified
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print('Login Page');
      {
        Get.offAll(() => const LoginPage());
      }
    }
    //else {
    //Get.offAll(() => WelcomePage(emails: user.email!));
    //}

    else {
      Get.offAll(() => home_screen(
            emails: user.email!,
          ));
    }
  }

  Future reset(BuildContext context, String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Password Reset link sent! Check your Email'),
          );
        },
      );
    } catch (e) {
      Get.snackbar("About Password", "Reset message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text("Email not found"),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  void register(String email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar("About User", "User message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text("Account Creation Failed"),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  void login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("About login", "login message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text("Signin Failed"),
          messageText: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ));
    }
  }

  void logout() async {
    await auth.signOut();
  }
}

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      return await _auth.signInWithCredential(credential);
    }
  } catch (error) {
    print("Google Sign-In Error: $error");
  }
}
