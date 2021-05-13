import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import './route_handlers.dart';

class Routes {
  static String home = "/";
  static String takePicture = "/picture/take";
  static String displayPicture = "/picture/show";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler =
        Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return;
    });
    router.define(home, handler: homeHandler);
    router.define(takePicture, handler: takePictureHandler);
    router.define(displayPicture, handler: displayPictureHandler);
  }
}
