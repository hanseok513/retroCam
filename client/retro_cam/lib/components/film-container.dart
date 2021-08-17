import 'package:flutter/material.dart';

class FilmContainer extends StatelessWidget {
  final String imagePath;
  final void Function() onClick;

  FilmContainer({Key key, this.imagePath, this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: FittedBox(
        child: Image.asset(imagePath),
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
