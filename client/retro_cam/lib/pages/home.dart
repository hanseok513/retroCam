import 'package:flutter/material.dart';
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakePictureScreen(),
            ),
          );
        },
      ),
    );
  }
}
