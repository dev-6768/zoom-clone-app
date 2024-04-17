import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zoom_clone_app/controller/send_call_controller.dart';
import 'package:zoom_clone_app/resources/firestore_resources.dart';
import 'package:zoom_clone_app/resources/utils.dart';
import 'package:zoom_clone_app/utils/colors.dart';
import 'package:zoom_clone_app/widgets/app_bar_widget.dart';

class CreateContactsPage extends StatefulWidget {
  const CreateContactsPage({super.key});

  @override
  State<CreateContactsPage> createState() => _CreateContactsPageState();
}

class _CreateContactsPageState extends State<CreateContactsPage> {
  @override
  final streamControllerForSearch = StreamController<dynamic>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidgetStateless(title: "Create Contact").build(context),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  colors: ColorTheme.gradientColorForCreateContactsBackground(),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: TextFormField(
                  onChanged: (value) {
                    streamControllerForSearch.sink.add(value);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    labelText: "Search",
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: InkWell(
                      onTap: () {
                        //TODO: to add functionality for fetching contacts
                        print("hello");
                      },
                      child: const Icon(Icons.search),    
                    ),
                  ),

                  keyboardType: TextInputType.number,
                ),
              ),
            ),

            SizedBox(height: 10),

            StreamBuilder<dynamic>(
            stream: streamControllerForSearch.stream,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              else {
                if(snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return streamBuilderForContacts(snapshot.data);
                  } 
                  
                  else {
                    return const Text('No text entered yet.');
                  }
                }

                else {
                  print(snapshot.connectionState);
                  return Center(
                    child: const Text("Nothing found"),
                  );
                }
              }
            },
          ),

            
          ],
        ),
      ),
    );
  }

  dynamic streamBuilderForContacts(String searchContactsText) {
    return Container(
      child: StreamBuilder(
      stream: FirebaseFirestore.instance.collection(FirebaseUtils.userCollectionName).where('phoneNumber', isEqualTo: searchContactsText).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        else {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          else {
            if(snapshot.hasData) {
              if(snapshot.data!.docs.isEmpty || snapshot.data!.docs == null ){
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
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: ColorTheme.gradientColorForCreateContactsBackground(),
                    ),
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      // Here you can create widgets to display data from each document
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: Image.network(document['profilePhoto']).image),
                        title: Text(document['username']),
                        subtitle: Text(document['phoneNumber']),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            InkWell(
                              onTap: () async {
                                await FirebaseFirestoreServices.addToContacts(
                                  document["username"], 
                                  document["uid"], 
                                  document["phoneNumber"], 
                                  document["profilePhoto"], 
                                  document["email"], 
                                  document["fcmToken"],
                                  context
                                );
                              },

                              child: Text(
                                "ADD",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                )
                              )
                            ),

                            SizedBox(width: 10),

                            InkWell(
                              onTap: () async {
                                final uuidForCallRoom = const Uuid().v1();
                                await SendPostRequest.sendCallNotification(
                                  document["fcmToken"],
                                  uuidForCallRoom,
                                );
                              },

                              child: const Text(
                                "CALL",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                )
                              )
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            }

            else {
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
          }
        }
      },
    ),
    );
  }

}