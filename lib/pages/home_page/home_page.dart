import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoom_clone_app/resources/utils.dart';
import 'package:zoom_clone_app/widgets/app_bar_widget.dart';

import '../../widgets/bottom_nav_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidgetStateless(title: "Meet and Chat").build(context),
      bottomNavigationBar: const BottomNavigationBarWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
            Center(
              child: Text(
                "Zoom",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            
            const Center(
              child: SingleChildScrollView(
                child: HomePageBody(),
              ),
              
            ),
        ]
      ),
      );
  }
}

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.5,
      child: Center(
        child: GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          children: ConstantUtils.homeOptions(context)
          ),
      ),
    );
  }
}

class ContainerForMeetWidget extends StatefulWidget {
  final IconData iconPath;
  final String description;  
  final void Function()? onTap;
  const ContainerForMeetWidget({super.key, required this.iconPath, required this.description, required this.onTap});

  @override
  State<ContainerForMeetWidget> createState() => _ContainerForMeetWidgetState();
}

class _ContainerForMeetWidgetState extends State<ContainerForMeetWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(1),
            border: Border.all(width: 0.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,

              children: [
                Icon(widget.iconPath),
                SizedBox(height: 2),
                Text(
                  widget.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}