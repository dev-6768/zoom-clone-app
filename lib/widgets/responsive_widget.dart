import 'package:flutter/material.dart';

class ResponsiveWidget extends StatefulWidget {
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;
  
  const ResponsiveWidget({super.key, required this.largeScreen, required this.mediumScreen, required this.smallScreen});

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1000;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 700 && MediaQuery.of(context).size.width < 1000;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 700;
  }

  @override
  State<ResponsiveWidget> createState() => _ResponsiveWidgetState();
}

class _ResponsiveWidgetState extends State<ResponsiveWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(context, constraints) {
        if(constraints.maxWidth >= 1000) {
          return widget.largeScreen;
        }

        else if(constraints.maxWidth <= 700 && constraints.maxWidth < 1000) {
          return widget.mediumScreen;
        }

        else {
          return widget.smallScreen;
        }
      }
    );
  }
}