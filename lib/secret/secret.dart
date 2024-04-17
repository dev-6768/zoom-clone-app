import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZegoCloudAppConstants {
  static const zegoCloudAppId = 1346483092;
  static const zegoCloudAppSign = "4a92eddb0fab4acdb62dba5192db21c55f3a8dfbdd1daa919591ccac50027d03";
}

class FCMServerCredentials {
  static const projectId = "zoom-clone-app-3b047";
  static const projectNumber = 364108525373;
  static getBearerToken() async {
    final getBearerToken = await FirebaseFirestore.instance.collection("secret").where("userId", isEqualTo: "cgZc7pukT7TH993t1WY2").get();
    final bearerToken = getBearerToken.docs[0]["fcmAPIToken"];
    final zegoAppId = getBearerToken.docs[0]["zegoAppId"];
    final zegoAppSign = getBearerToken.docs[0]["zegoAppSign"];
    final zoomProjectId = getBearerToken.docs[0]["zoomProjectId"];
    final zoomProjectNumber = getBearerToken.docs[0]["zoomProjectNumber"];

    final SharedPreferences localPrefs = await SharedPreferences.getInstance();
    await localPrefs.setString("bearerToken", bearerToken);
    await localPrefs.setInt("zegoAppId", zegoAppId);
    await localPrefs.setString("zegoAppSign", zegoAppSign);
    await localPrefs.setString("zoomProjectId", zoomProjectId);
    await localPrefs.setInt("zoomProjectNumber", zoomProjectNumber);
    
    print("bearerToken : $bearerToken");
    return bearerToken;

  }
}