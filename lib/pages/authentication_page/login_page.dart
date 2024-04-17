import 'package:flutter/material.dart';
import 'package:zoom_clone_app/pages/authentication_page/register_page.dart';
import 'package:zoom_clone_app/resources/auth_resources.dart';
import 'package:zoom_clone_app/utils/constants.dart';
import 'package:zoom_clone_app/utils/routes.dart';
import 'package:zoom_clone_app/widgets/app_bar_widget.dart';
import 'package:zoom_clone_app/widgets/button_widget.dart';
import 'package:zoom_clone_app/widgets/image_network_widget.dart';
import 'package:zoom_clone_app/widgets/text_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthResources _authResources = AuthResources();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(
      
      child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.center,
            child: TextWidget(textArg: "Start or join a meeting"),
          ),

          const SizedBox(height: 20),

          Center(
            child: ImageNetworkImage(imageString: assetOnboardingForHomePage),
          ),

          const SizedBox(height: 20),

          Center(
            child: CustomButton(
              textArg: "Google Sign In",
              onPressed: () async {
                bool res = await _authResources.signInWithGoogle(context);

                if(res) {
                  if(context.mounted) {
                    Navigator.pushNamed(context, homeRoute);  
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: CustomButton(
              textArg: "Register",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => 
                      const RegisterPage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: CustomButton(
              textArg: "Log in",
              onPressed: () async {
                Navigator.push(
                 context,
                 MaterialPageRoute(
                  builder: (context) => 
                    const LoginPageWidget(),
                 )
                );
              },
            ),
          ),
          
        ],
      ),
      ),
      ), 
      ),
      ),
    );
  }
}