import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoom_clone_app/utils/colors.dart';
import 'package:zoom_clone_app/widgets/text_widget.dart';

class AppBarWidget extends StatefulWidget {
  final String title;

  const AppBarWidget({super.key, required this.title});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: TextWidget(textArg: widget.title),
      elevation: 0,
      centerTitle: true,
      backgroundColor: backgroundColor,
    );
  }
}

class AppBarWidgetStateless extends StatelessWidget {
  final String title;
  const AppBarWidgetStateless({super.key, required this.title});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.0,
          color: Colors.white,
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor,
      elevation: 0,
    );
  }
}