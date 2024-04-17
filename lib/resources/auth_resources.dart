import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_clone_app/pages/home_page/home_page.dart';
import 'package:zoom_clone_app/resources/utils.dart';
import 'package:zoom_clone_app/utils/utils.dart';

class AuthResources {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<User?> get authChanges => _auth.authStateChanges();

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication; 
      final credential  = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if(user != null) {
        if(userCredential.additionalUserInfo!.isNewUser) {
          final SharedPreferences localPrefs = await SharedPreferences.getInstance();
          final fcmToken = localPrefs.getString("fcmToken");
          await _firestore.collection(FirebaseUtils.userCollectionName).doc(user.uid).set({
            'username': user.displayName,
            'uid': user.uid,
            'profilePhoto': user.photoURL,
            "phoneNumber": user.phoneNumber,
            "email": user.email,
            "fcmToken": fcmToken,
          });

          return true;
        }

        else {
          final SharedPreferences localPrefs = await SharedPreferences.getInstance();
          if(context.mounted) {
            final userDocument = await returnUserWithUserId(user.uid, context);
            await localPrefs.setString("userName", userDocument["username"]);
            await localPrefs.setString("phoneNumber", userDocument["phoneNumber"]);
            await localPrefs.setString("email", userDocument["email"]);
            await localPrefs.setString("profilePhoto", userDocument["profilePhoto"]);
          }
          return true;
        }
      }

      else {
        return false;
      }
    }

    catch(exception) {
      // if(exception.toString() != "PlatformException(popup_closed_by_user, Exception raised from GoogleAuth.signIn(), https://developers.google.com/identity/sign-in/web/reference#error_codes_2, null)") {
      //   showSnackBar(context, exception.toString());
      //   print(exception.toString());
      //   res = false;
      // }
      // else {
      //   showSnackBar(context, "Sign In Window Closed by User");
      //   res = false;
      // }
      if(context.mounted) {
        showSnackBar(context, "Some error encountered while signing in.");
      }
      
    }
    return res;  
  }

  static signInWithEmailAndPassword(String userName, String password, String phoneNumber, String email, String profilePhoto, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final _firestore = FirebaseFirestore.instance;
      final SharedPreferences localPrefs = await SharedPreferences.getInstance();
      final fcmToken = localPrefs.getString("fcmToken");
      await _firestore.collection(FirebaseUtils.userCollectionName).doc().set({
        'username': userName,
        'uid': userCredential.user!.uid,
        'profilePhoto': profilePhoto,
        "phoneNumber": phoneNumber,
        "email": email,
        "fcmToken": fcmToken,
      });

      if(context.mounted) {
        showSnackBar(context, "User registered successfully");
      }
    }

    catch(exception) {
      if(context.mounted) {
        showSnackBar(context, "Failed to register user");
      }
    }
  }

  static loginWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if(context.mounted) {
        final userDocument = await returnUserWithEmail(email, context);
        final SharedPreferences localPrefs = await SharedPreferences.getInstance();
        await localPrefs.setString("userName", userDocument["username"]);
        await localPrefs.setString("phoneNumber", userDocument["phoneNumber"]);
        await localPrefs.setString("email", userDocument["email"]);
        await localPrefs.setString("profilePhoto", userDocument["profilePhoto"]);
      }
      
      User? user = userCredential.user;
      if(context.mounted) {
        showSnackBar(context, "Logged in successfully.");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => 
            const HomePage()
          )
        );
      }
      return user!.uid;  
    }

    catch(exception) {
      if(context.mounted) {
        showSnackBar(context, "Cannot log in user.");
      }
    }
    
  }

  static signOutUserWithEmailAndPassword() async {
    await FirebaseAuth.instance.signOut();
  }

  static returnUserWithUserId(String userId, BuildContext context) async {
    try {
      final firestoreDocument = await FirebaseFirestore.instance.collection(FirebaseUtils.userCollectionName).where("uid", isEqualTo: userId).get();
      if(context.mounted) {
        if(firestoreDocument.docs != null && firestoreDocument.docs.isNotEmpty) {
          showSnackBar(context, "User fetched successfully.");
          return firestoreDocument.docs[0];
        }
        else {
          showSnackBar(context, "Failed to fetch user data.");
        }
      }
    }

    catch(exception) {
      if(context.mounted) {
        showSnackBar(context, "Failed to fetch user data.");
      }
      
    }
  }

  static returnUserWithEmail(String email, BuildContext context) async {
      try {
        final firestoreDocument = await FirebaseFirestore.instance.collection(FirebaseUtils.userCollectionName).where("email", isEqualTo: email).get(); 
          if(context.mounted) {
          if(firestoreDocument.docs != null && firestoreDocument.docs.isNotEmpty) {
            showSnackBar(context, "User fetched successfully.");
            return firestoreDocument.docs[0];
          }
          else {
            showSnackBar(context, "Failed to fetch user data.");
          }
        }
      }

      catch(exception) {
        if(context.mounted) {
          showSnackBar(context, "Failed to fetch data");
        }
      }
  }
}