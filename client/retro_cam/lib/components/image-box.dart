import 'package:flutter/material.dart';

class CroppedImageBox extends StatelessWidget {
  final Image image;
  final double aspectRatio;

  CroppedImageBox({Key key, this.image, this.aspectRatio});

  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: this.aspectRatio,
      child: new Container(
        decoration: new BoxDecoration(
          color: Colors.white,
          image: new DecorationImage(
            fit: BoxFit.contain,
            alignment: FractionalOffset.center,
            image: this.image.image,
          ),
        ),
      ),
    );
  }
}
