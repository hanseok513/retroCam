import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:retro_cam/pages/display-picture.dart';
import 'package:retro_cam/pages/home.dart';
import 'package:retro_cam/pages/take-picture.dart';

var homeHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return HomeScreen();
});

var takePictureHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TakePictureScreen();
});

class DisplayPictureArgument {
  final String imagePath;

  DisplayPictureArgument(this.imagePath);
}

var displayPictureHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  final argument = context.settings.arguments as DisplayPictureArgument;

  return DisplayPictureScreen(imagePath: argument.imagePath);
});
