import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_clone_app/pages/call_pages/call_page.dart';
import 'package:zoom_clone_app/secret/secret.dart';

class SendPostRequest {
  static sendCallToDevice(String title, String bodyMessage, String deviceToken, String roomId) async {
    final SharedPreferences localPrefs = await SharedPreferences.getInstance();
    var url = Uri.parse('https://fcm.googleapis.com/v1/projects/${localPrefs.getString("zoomProjectId")}/messages:send');

    var body = {
      "message":{
          "token": deviceToken,
          "notification":{
            "body": bodyMessage,
            "title":title,
          },
          "data":{
            "room":roomId,
          }
      }
    };

    var bodyPayload = jsonEncode(body);

    try {
      var response = await http.post(
        url,
        body: bodyPayload,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer "${localPrefs.getString("bearerToken")}"',
        },
      );

      print("response");
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('POST request successful');
        print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } 
      
      else {
        print('POST request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }   
  }

  static sendCallNotification(String deviceToken, String roomId) async {
    final SharedPreferences localPrefs = await SharedPreferences.getInstance();
    final title = (FirebaseAuth.instance.currentUser!.displayName != null) ? FirebaseAuth.instance.currentUser!.displayName! : localPrefs.getString("userName")!;
    const bodyMessage = "Zoom Incoming Call";

    await sendCallToDevice(
      title, 
      bodyMessage, 
      deviceToken, 
      roomId
    );

    Get.to(CallPage(callIdForZego: roomId, userId: FirebaseAuth.instance.currentUser!.uid, userName: title));
  }
}