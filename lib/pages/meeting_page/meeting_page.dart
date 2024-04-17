import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_clone_app/pages/call_pages/call_page.dart';
import 'package:zoom_clone_app/resources/utils.dart';
import 'package:zoom_clone_app/utils/colors.dart';
import 'package:zoom_clone_app/widgets/app_bar_widget.dart';
import 'package:zoom_clone_app/widgets/bottom_nav_bar_widget.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidgetStateless(title: "Your Meetings").build(context),
      bottomNavigationBar: BottomNavigationBarWidget(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: ColorTheme.gradientColorForMeetingPageBackground(),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        child: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(FirebaseUtils.meetingCollectionName).where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Encountered an error while loading data.'),
                );
              }

            if(snapshot.data!.docs.isEmpty || snapshot.data!.docs == null) {
              return const Center(
                child: const Text("No meetings here."),
              );
            }

            else {
              return ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return ListTile(
                  title: Text(ConstantUtils.stringCapitalization(document['status'])),
                  subtitle: Text(ConstantUtils.dateTimeUtils(document['date'])),
                  trailing: Container(
                    child: InkWell(
                      onTap: () async {
                        final SharedPreferences localPrefs = await SharedPreferences.getInstance();
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) =>
                            CallPage(
                              callIdForZego: document["meetingCode"], 
                              userId: FirebaseAuth.instance.currentUser!.uid, 
                              userName: (FirebaseAuth.instance.currentUser!.displayName != null) ? FirebaseAuth.instance.currentUser!.displayName! : localPrefs.getString("userName")!)
                          )
                        );
                      },

                      child: const Text("JOIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0))
                    ),
                  ),
                );
              }).toList(),
            );
            }
            }
          },
        ),
      ),
      ),
    ),
      ),
      
      
    );
  }
}