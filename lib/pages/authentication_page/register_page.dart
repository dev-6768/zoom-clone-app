import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_clone_app/pages/authentication_page/login_page.dart';
import 'package:zoom_clone_app/resources/auth_resources.dart';
import 'package:zoom_clone_app/resources/utils.dart';
import 'package:zoom_clone_app/utils/colors.dart';
import 'package:zoom_clone_app/widgets/app_bar_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  String downloadProfileImageString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidgetStateless(title: "Register").build(context),
      body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,

          children: [
            customCircleAvatarForAuthentication(),
            const SizedBox(height: 30),
            customTextContainerForAuthentication("Name", userNameTextController),
            const SizedBox(height: 10,),
            customTextContainerForAuthentication("Password", passwordTextEditingController, password: true),
            const SizedBox(height: 10,),
            customTextContainerForAuthentication("Phone Number", phoneNumberTextController),
            const SizedBox(height: 10),
            customTextContainerForAuthentication("Email", emailTextEditingController),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                await AuthResources.signInWithEmailAndPassword(
                  userNameTextController.text,
                  passwordTextEditingController.text,
                  phoneNumberTextController.text,
                  emailTextEditingController.text,
                  downloadProfileImageString,
                  context
                );
              },

              style: ElevatedButton.styleFrom(
                elevation: 0, // Remove elevation
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding as needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Set button border radius here
                ),
              ),

              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                )
              ),
            ),
          ],
        ),
      ),
    ),
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

  Widget customCircleAvatarForAuthentication() {
    final streamForProfileImageUpload = StreamController<dynamic>();
    return InkWell(
      onTap: () async {
        String downloadUrl = await ConstantUtils.imagePickerService(context);
        streamForProfileImageUpload.sink.add(downloadUrl);
      },

      child: StreamBuilder<dynamic>(
        stream: streamForProfileImageUpload.stream,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          else {
            if(snapshot.hasError) {
              return const Center(
                child: Text('Error: Encountered an error'),
              );
            }

            else {
              if(snapshot.hasData) {
                if(snapshot.data == "" || snapshot.data == null ){
                  return const Center(
                    child: Text(
                      "No Contact found",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0
                      )
                    ),
                  );
                }

                else {
                  downloadProfileImageString = snapshot.data;
                  return CircleAvatar(
                    backgroundImage: Image.network(snapshot.data).image,
                    radius: 40.0,
                  );
                }
              }

              else {
                return const Center(
                  child: Text(
                    "No Image Selected",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidgetStateless(title: "Login Page").build(context),
      body: FutureBuilder<List<String?>?>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } 
        
        else if (snapshot.hasError) {
          return futureBuilderWrapper("", "");
        } 
        
        else {
          List<String?>? data = snapshot.data;
          if (data == null || data.contains(null) || data.contains("")) {
            return futureBuilderWrapper("", "");
          } 
          
          else {
            return futureBuilderWrapper(data[0]!, data[1]!);
          }
        }
      },
    ),
    );
  }

  Widget futureBuilderWrapper(String loginEmail, String loginPassword) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,

            children: [
              customTextContainerForAuthentication("Email", emailTextEditingController, loginEmail),
              const SizedBox(height: 10),
              customTextContainerForAuthentication("Password", passwordTextEditingController, password: true, loginPassword),
              const SizedBox(height: 10),

              ElevatedButton(
              onPressed: () async {
                await AuthResources.loginWithEmailAndPassword(
                  emailTextEditingController.text,
                  passwordTextEditingController.text,
                  context
                );

                final SharedPreferences localPrefs = await SharedPreferences.getInstance();
                await localPrefs.setString("loginEmail", emailTextEditingController.text);
                await localPrefs.setString("loginPassword", passwordTextEditingController.text);
              },

              style: ElevatedButton.styleFrom(
                elevation: 0, // Remove elevation
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // Adjust padding as needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Set button border radius here
                ),
              ),

              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                )
              ),
            ),

            ],
          ),
        ),
      );
  }

  Widget customTextContainerForAuthentication(String labelText, TextEditingController textController, String? loginCredentials, {bool password = false}) {
    textController.text = (loginCredentials != null) ? loginCredentials : "";
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

  Future<List<String?>?> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginEmail = prefs.getString("loginEmail");
    String? loginPassword = prefs.getString("loginPassword");
    return [loginEmail, loginPassword];
  }
}
