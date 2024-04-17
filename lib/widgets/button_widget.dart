import 'package:flutter/material.dart';
import 'package:zoom_clone_app/utils/colors.dart';
import 'package:zoom_clone_app/widgets/text_widget.dart';

class CustomButton extends StatefulWidget {
  final String textArg;
  final void Function()? onPressed;
  const CustomButton({super.key, required this.textArg, required this.onPressed});


  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.5,
      height: MediaQuery.of(context).size.height*0.08,
      child: ElevatedButton(
      onPressed: widget.onPressed,  
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: Size(
          MediaQuery.of(context).size.width,
          50,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: buttonColor),
        )
      ),
      child: TextWidget(textArg: widget.textArg),
    ),
    );
  }
}