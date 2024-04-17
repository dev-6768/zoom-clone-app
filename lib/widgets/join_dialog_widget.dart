import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_clone_app/pages/call_pages/call_page.dart';
import 'package:flutter/services.dart';
import 'package:zoom_clone_app/resources/auth_resources.dart';
import 'package:zoom_clone_app/resources/firestore_resources.dart';
import 'package:zoom_clone_app/utils/colors.dart';
import 'package:zoom_clone_app/utils/utils.dart';

class JoinAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController joiningController = TextEditingController();
    return AlertDialog(
      title: Text('Join Meeting'),
      content: TextFormField(
        controller: joiningController,
        decoration: InputDecoration(
          hintText: 'Enter meeting code',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            final SharedPreferences localPrefs = await SharedPreferences.getInstance();
            if(joiningController.text != "" && joiningController.text != null) {
              await FirebaseFirestoreServices.addMeeting(
                "joined",
                DateTime.now().toString(), 
                joiningController.text,
                context
              );
            
              Navigator.of(context).pop();
              
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder:(context) => 
                  CallPage(
                    callIdForZego: joiningController.text, 
                    userId: FirebaseAuth.instance.currentUser!.uid, 
                    userName: (FirebaseAuth.instance.currentUser!.displayName != null) ? FirebaseAuth.instance.currentUser!.displayName! : localPrefs.getString("userName")!,
                  )
                )
              );
            }

            else {
              showSnackBar(context, "Please enter the meeting code");
            }
            
          },
          child: const Text('JOIN'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}

class CreateMeetingDialog extends StatelessWidget {
  final String meetingCode;
  const CreateMeetingDialog({super.key, required this.meetingCode});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Meeting'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Meeting has been created successfully",
          ),

          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: meetingCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Meeting code copied')),
              );
            },
            child: const Text('Copy Meeting Code'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () async {
            if(context.mounted) {
              final SharedPreferences localPrefs = await SharedPreferences.getInstance();
              await FirebaseFirestoreServices.addMeeting(
                "created",
                DateTime.now().toString(), 
                meetingCode,
                context
              );

              Navigator.of(context).pop();
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => 
                  CallPage(
                    callIdForZego: meetingCode, 
                    userId: FirebaseAuth.instance.currentUser!.uid, 
                    userName: (FirebaseAuth.instance.currentUser!.displayName != null) ? FirebaseAuth.instance.currentUser!.displayName! : localPrefs.getString("userName")!
                  )
                )
              );
            }
          },
          child: const Text('JOIN'),
        ),
      ],
    );
  }
}

class LoginDialog extends StatelessWidget {
  final String uuidForMeet;
  LoginDialog({super.key, required this.uuidForMeet});
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          customTextContainerForAuthentication("Email", emailTextController),
          const SizedBox(height: 16),
          customTextContainerForAuthentication("Password", passwordTextEditingController, password: true),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            try {
              await AuthResources.loginWithEmailAndPassword(emailTextController.text, passwordTextEditingController.text, context);
              final SharedPreferences localPrefs = await SharedPreferences.getInstance();
              if(context.mounted) {
                final userDocument = AuthResources.returnUserWithUserId(FirebaseAuth.instance.currentUser!.uid, context);
                await localPrefs.setString("userName", userDocument["username"]);
                await localPrefs.setString("phoneNumber", userDocument["phoneNumber"]);
                await localPrefs.setString("email", userDocument["email"]);
                await localPrefs.setString("profilePhoto", userDocument["profilePhoto"]);
              }
              
              if(FirebaseAuth.instance.currentUser != null) {
                if(context.mounted) {
                  showSnackBar(context, "Login Successfull");
                  Get.to(CallPage(callIdForZego: uuidForMeet, userId: FirebaseAuth.instance.currentUser!.uid, userName: localPrefs.getString("userName")!));
                }
              }

              else {
                if(context.mounted) {
                  showSnackBar(context, "Login failed");
                }
              }
            }

            catch(exception) {
              if(context.mounted) {
                showSnackBar(context, "Login Failed");
              }
            }
            
          },
          child: const Text('Login'),
        ),
        TextButton(
          onPressed: () async {
            bool res = await AuthResources().signInWithGoogle(context);
            if(res) {
              try {
                final SharedPreferences localPrefs = await SharedPreferences.getInstance();
                final userDocument = AuthResources.returnUserWithUserId(FirebaseAuth.instance.currentUser!.uid, context);
                await localPrefs.setString("userName", userDocument["username"]);
                await localPrefs.setString("phoneNumber", userDocument["phoneNumber"]);
                await localPrefs.setString("email", userDocument["email"]);
                await localPrefs.setString("profilePhoto", userDocument["profilePhoto"]);
                await localPrefs.setString("fcmToken", userDocument["fcmToken"]);

                if(FirebaseAuth.instance.currentUser != null) {
                  if(context.mounted) {
                    showSnackBar(context, "Login Successfull");
                    Get.to(CallPage(callIdForZego: uuidForMeet, userId: FirebaseAuth.instance.currentUser!.uid, userName: localPrefs.getString("userName")!));
                  }
                }

                else {
                  if(context.mounted) {
                    showSnackBar(context, "Login failed");
                  }
                }
              }

              catch(exception) {
                if(context.mounted) {
                  showSnackBar(context, "Login Failed");
                }
              }
            }

            else {
              if(context.mounted) {
                showSnackBar(context, "Login Failed");
              }
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Google sign in'),
            ],
          ),
        ),
      ],
    );
  }

  Widget customTextContainerForAuthentication(String labelText, TextEditingController textController, {bool password = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: ColorTheme.gradientColorForCreateContactsBackground()
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: labelText,
            hintText: labelText,  
          ),
          controller: textController,
          obscureText: password,
        )
      ),
    );
  }
}