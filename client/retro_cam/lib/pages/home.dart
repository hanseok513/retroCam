import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:retro_cam/config/application.dart';
import 'package:retro_cam/config/routes.dart';
import 'package:retro_cam/pages/take-picture.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(title: Text('This will be home')),
      floatingActionButton: FloatingActionButton(
        child: Text('Go to Camera'),
        onPressed: () {
          Application.router.navigateTo(
            context,
            Routes.takePicture,
            transition: TransitionType.inFromRight,
          );
        },
      ),
    );
  }
}
