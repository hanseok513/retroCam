import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_cam/main.dart';

class TakePictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CameraState>(builder: (context, cameraState, child) {
      return FutureBuilder<List<CameraDescription>>(
        future: cameraState.cameras,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _TakePictureBody(camera: snapshot.data.first);
          }
          return CircularProgressIndicator();
        },
      );
    });
  }
}

class _TakePictureBody extends StatefulWidget {
  final CameraDescription camera;

  const _TakePictureBody({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _TakePictureBodyState createState() => _TakePictureBodyState();
}

class _TakePictureBodyState extends State<_TakePictureBody> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}

class _DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const _DisplayPictureScreen({
    Key key,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
