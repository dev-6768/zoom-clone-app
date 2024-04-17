import 'package:flutter/material.dart';
import 'package:zoom_clone_app/widgets/responsive_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatefulWidget {
  final String textArg;
  const TextWidget({super.key, required this.textArg});

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {

  double fontSize = 0;
  List<double> reszizingForTextWidget() {
    if(ResponsiveWidget.isLargeScreen(context)) {
      setState(() {
        fontSize = 14.0;  
      });
      
    }

    else if(ResponsiveWidget.isMediumScreen(context)) {
      setState(() {
        fontSize = 12.0;  
      });
    }

    else {
      setState(() {
        fontSize = 10.0;  
      });
    }

    return [fontSize];
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.textArg,
      style: TextStyle(
        fontFamily: GoogleFonts.lato().fontFamily,
        fontSize: reszizingForTextWidget()[0],
        fontWeight: FontWeight.bold,
      ),
      
    );
  }
}