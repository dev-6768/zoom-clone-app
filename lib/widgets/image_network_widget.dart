import 'package:flutter/material.dart';

class ImageNetworkImage extends StatefulWidget {
  final String imageString;
  const ImageNetworkImage({super.key, required this.imageString});

  @override
  State<ImageNetworkImage> createState() => _ImageNetworkImageState();
}

class _ImageNetworkImageState extends State<ImageNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.imageString,
      fit: BoxFit.fill,
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.5,
    );
  }
}