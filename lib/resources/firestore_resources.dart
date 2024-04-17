import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_clone_app/pages/call_pages/call_page.dart';
import 'package:zoom_clone_app/resources/auth_resources.dart';
import 'package:zoom_clone_app/resources/utils.dart';
import 'package:zoom_clone_app/utils/utils.dart';
import 'package:flutter/material.dart';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:zoom_clone_app/widgets/join_dialog_widget.dart';

class FirebaseFirestoreServices {

  static addMeeting(String status, String date, String meetingCode, BuildContext context) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userDocument = await AuthResources.returnUserWithUserId(FirebaseAuth.instance.currentUser!.uid, context);

      await firestore.collection(FirebaseUtils.meetingCollectionName).doc().set({
        "status":status,
        "date":date,
        "meetingCode":meetingCode,
        "userId":  FirebaseAuth.instance.currentUser!.uid,
        "userName": (FirebaseAuth.instance.currentUser!.displayName != null) ? FirebaseAuth.instance.currentUser!.displayName : userDocument["username"],
        "phoneNumber": (FirebaseAuth.instance.currentUser!.phoneNumber != null) ? FirebaseAuth.instance.currentUser!.phoneNumber : userDocument["phoneNumber"],
        "profilePhoto": (FirebaseAuth.instance.currentUser!.photoURL != null) ? FirebaseAuth.instance.currentUser!.photoURL : userDocument["profilePhoto"],
      });

      if(context.mounted)  {
        showSnackBar(context, "Meeting saved successfully.");
      }
    }

    catch(exception) {
      if(context.mounted)  {
        showSnackBar(context, "Failed to save meeting");
      }
    }

  }

  static addToContacts(String contactName, String contactUserId, String contactPhoneNumber, String contactProfilePhoto, String contactEmail, String contactFcmToken, BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    final userDocument = await AuthResources.returnUserWithUserId(FirebaseAuth.instance.currentUser!.uid, context);
    try {
      await firestore.collection(FirebaseUtils.contactsCollectionName).doc().set({
        "name": (FirebaseAuth.instance.currentUser!.displayName != null) ? FirebaseAuth.instance.currentUser!.displayName : userDocument["username"],
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "phoneNumber": (FirebaseAuth.instance.currentUser!.phoneNumber != null) ? FirebaseAuth.instance.currentUser!.displayName : userDocument["phoneNumber"],
        "profilePhoto": (FirebaseAuth.instance.currentUser!.photoURL != null) ? FirebaseAuth.instance.currentUser!.photoURL : userDocument["profilePhoto"],
        "email": (FirebaseAuth.instance.currentUser!.email != null) ? FirebaseAuth.instance.currentUser!.email : userDocument["email"],
        "contactName": contactName,
        "contactUserId": contactUserId,
        "contactPhoneNumber": contactPhoneNumber,
        "contactProfilePhoto": contactProfilePhoto,
        "contactEmail": contactEmail,
        "contactFcmToken": contactFcmToken,
      });

      if(context.mounted) {
        showSnackBar(context, "Contact added successfully");
      }
    }

    catch(exception) {
      if(context.mounted) {
        showSnackBar(context, "Failed to add contact.");
      }
      
    }
    
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title : ${message.notification?.title}");
  print("Body : ${message.notification?.body}");
  print("Payload : ${message.data}");
}

void handleMessage(RemoteMessage? message) async {
  if(message == null) {
    return;
  }

  else {
    final SharedPreferences localPrefs = await SharedPreferences.getInstance();
    if(FirebaseAuth.instance.currentUser != null) {
      Get.to(CallPage(
        callIdForZego: message.data["room"], 
        userId: FirebaseAuth.instance.currentUser!.uid, 
        userName: (FirebaseAuth.instance.currentUser!.displayName != null) ? FirebaseAuth.instance.currentUser!.displayName! : localPrefs.getString("userName")!,
      ));
    }

    else {
      Get.to(LoginDialog(uuidForMeet: message.data["room"]));
    }
    
  }

}

final _localNotifications = FlutterLocalNotificationsPlugin();
final _androidChannel = const AndroidNotificationChannel(
  'high_inportance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.defaultImportance,
);

Future initPushNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );


  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  FirebaseMessaging.onMessage.listen((event) { 
    final notification = event.notification;
    if(notification == null) {
      return;
    }

    else {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/launch_background'
          ),
        ),
        payload: jsonEncode(event.toMap()),
      );
    }
  });
}
 

Future initLocalNotifications() async {
  const android = AndroidInitializationSettings('@drawable/launch_background');
  const settings = InitializationSettings(android: android);
  await _localNotifications.initialize(
    settings,
    onSelectNotification: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload!));
      handleMessage(message);
    }
  );

  final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await platform?.createNotificationChannel(_androidChannel);
}


class FirebaseApiInterface {
  final _firebaseMessaging = FirebaseMessaging.instance;  

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    final SharedPreferences localPrefs = await SharedPreferences.getInstance();
    await localPrefs.setString("fcmToken", fcmToken!);
    print("Token : $fcmToken");

    initPushNotifications();
    initLocalNotifications();
  }
}