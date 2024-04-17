import 'package:flutter/material.dart';

const backgroundColor = Color.fromRGBO(36,36,36,1);
const buttonColor = Color.fromRGBO(14,114,236,1);
const footerColor = Color.fromRGBO(26,26,26,1);
const secondaryBackgroundColor = Color.fromRGBO(46,46,46,1);  

class ColorTheme {
  static gradientColorForMeetingPageBackground() {
    return [
      const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
      const Color.fromARGB(255, 22, 22, 22).withOpacity(0.3),
      const Color.fromARGB(255, 79, 79, 79).withOpacity(0.3),
      const Color.fromARGB(255, 96, 96, 96).withOpacity(0.3),
    ];
  }

  static gradientColorForCreateContactsBackground() {
    return [
      const Color.fromARGB(255, 244, 244, 244).withOpacity(0.3),
      const Color.fromARGB(255, 232, 232, 232).withOpacity(0.3),
      const Color.fromARGB(255, 211, 211, 211).withOpacity(0.3),
      const Color.fromARGB(255, 206, 206, 206).withOpacity(0.3),
    ];
  }
}