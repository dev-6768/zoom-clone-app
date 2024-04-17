import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zoom_clone_app/controller/send_call_controller.dart';
import 'package:zoom_clone_app/pages/contacts_pages/create_contacts_page.dart';
import 'package:zoom_clone_app/resources/utils.dart';
import 'package:zoom_clone_app/utils/colors.dart';
import 'package:zoom_clone_app/widgets/app_bar_widget.dart';
import 'package:zoom_clone_app/widgets/bottom_nav_bar_widget.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidgetStateless(title: "Your Contacts").build(context),
      bottomNavigationBar: const BottomNavigationBarWidget(),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
           MaterialPageRoute(
              builder: (context) => 
                const CreateContactsPage(),
            ),
          );
        },

        child: const Icon(Icons.add_call),
      ),
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
          stream: FirebaseFirestore.instance.collection(FirebaseUtils.contactsCollectionName).where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Encountered an error while loading data.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                );
              }

            if(snapshot.data!.docs.isEmpty || snapshot.data!.docs == null) {
              return const Center(
                child: Text(
                  "No contacts here.", 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              );
            }

            else {
              return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return ListTile(
                leading: CircleAvatar(
                  backgroundImage: Image.network(document['contactProfilePhoto']).image
                ),
                title: Text(document['contactName']),
                subtitle: Text(document['contactPhoneNumber']),
                trailing: Container(
                  child: InkWell(
                    onTap: () async {
                      final uuidForCallRoom = const Uuid().v1();
                      await SendPostRequest.sendCallNotification(
                        document["contactFcmToken"],
                        uuidForCallRoom,
                      );
                    },

                    child: const Text(
                      "CALL",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
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
