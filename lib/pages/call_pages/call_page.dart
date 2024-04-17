import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:zoom_clone_app/secret/secret.dart';
import 'package:zoom_clone_app/widgets/app_bar_widget.dart';

class CallPage extends StatefulWidget {
  final String callIdForZego;
  final String userId;
  final String userName;
  const CallPage({super.key, required this.callIdForZego, required this.userId, required this.userName});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidgetStateless(title: "Meet and Chat").build(context),
      body: ZegoUIKitPrebuiltVideoConference(
        appID: ZegoCloudAppConstants.zegoCloudAppId, 
        appSign: ZegoCloudAppConstants.zegoCloudAppSign, 
        conferenceID: widget.callIdForZego,
        userID: widget.userId, 
        userName: widget.userName, 
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}