import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:zoom_clone_app/pages/contacts_pages/contact_page.dart';
import 'package:zoom_clone_app/pages/home_page/home_page.dart';
import 'package:zoom_clone_app/pages/meeting_page/meeting_page.dart';
import 'package:zoom_clone_app/utils/utils.dart';
import 'package:zoom_clone_app/widgets/join_dialog_widget.dart';

class ConstantUtils {
  static dateTimeUtils(String date) {
    String year = DateTime.parse(date).year.toString();
    String month = DateTime.parse(date).month.toString();
    String day = DateTime.parse(date).day.toString();

    String hours = DateTime.parse(date).hour.toString();
    String minutes = DateTime.parse(date).minute.toString();

    if(minutes == "0") {
      minutes = "00";
    }

    return "$day-$month-$year $hours:$minutes";
  }

  static stringCapitalization(String string) {
    return "${string[0].toUpperCase()}${string.substring(1)}";
  }

  static imagePickerService(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    dynamic filePath;

    if(pickedFile != null) {
      filePath = File(pickedFile.path);
      try {
        Reference ref = FirebaseStorage.instance.ref().child('profile_image/${DateTime.now()}.png');
        UploadTask uploadTask = ref.putFile(filePath!);
        TaskSnapshot snapshot = await uploadTask;

        String downloadUrl = await snapshot.ref.getDownloadURL();
        if(context.mounted) {
          showSnackBar(context, "Image uploaded successfully");
        }

        return downloadUrl;
      }

      catch(exception) {
        if(context.mounted) {
          showSnackBar(context, "Cannot load image.");
        }
        return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKgZ2xNceDYV6TU4h3hRTqPWgQgoHcFg3R8w&usqp=CAU";
      }
    }

    else {
      if(context.mounted) {
        showSnackBar(context, "No image selected.");
      }

      return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKgZ2xNceDYV6TU4h3hRTqPWgQgoHcFg3R8w&usqp=CAU";
    }
  }

  static List<Widget> homeOptions(BuildContext context) {
    List<Widget> homeOptions = [
      ContainerForMeetWidget(
        iconPath: Icons.meeting_room,
        description: "Create a new meeting",
        onTap: () {
          final uniqueRoomId = Uuid();
          String uniqueStringRoomId = uniqueRoomId.v1();

          showDialog(context: context,
           builder: (context) {
            return CreateMeetingDialog(meetingCode: uniqueStringRoomId);
           }
          );
        }
      ),

      ContainerForMeetWidget(
        iconPath: Icons.time_to_leave,
        description: "Join a meet",
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return JoinAlertDialog(); // Show the AlertDialog
              },
            );
        }
      ),
      

      ContainerForMeetWidget(
        iconPath: Icons.contact_phone,
        description: "Contacts",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                const ContactsPage()
            ),
          );
        }
      ),
      

      ContainerForMeetWidget(
        iconPath: Icons.meeting_room,
        description: "Meetings",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => 
              const MeetingPage(),
            )
          );
        }
      ),
    ];
  return homeOptions;

  }
}

class HomeOptions {
  final IconData? iconData;
  final String description;
  final void Function()? onTap; 

  const HomeOptions({required this.iconData, required this.description, required this.onTap});
}

class FirebaseUtils {
  static const meetingCollectionName = "meetings";
  static const userCollectionName = "users";
  static const contactsCollectionName = "contacts";
}