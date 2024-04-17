import 'package:flutter/material.dart';
import 'package:zoom_clone_app/utils/colors.dart';


class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {

  int _page = 0;

  onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: footerColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      onTap: onPageChanged,
      currentIndex: _page,
      type: BottomNavigationBarType.fixed,
      unselectedFontSize: 14.0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.lock_clock), label: "Meetings"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Contacts"),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings"),
        BottomNavigationBarItem(icon: Icon(Icons.comment_bank), label: "Meet and Chat"),
      ],
    );
  }
}