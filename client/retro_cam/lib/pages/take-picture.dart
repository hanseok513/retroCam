import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:retro_cam/pages/strip.dart';

class AvailableCameraController {
  Future<List<CameraDescription>> _cameraDescription;

  AvailableCameraController() {
    _cameraDescription = availableCameras();
  }

  get cameras {
    return _cameraDescription;
  }
}

class TakePictureScreen extends StatelessWidget {
  final int index;
  final AvailableCameraController availableCameraController = Get.put(AvailableCameraController());
  TakePictureScreen({Key key, this.index = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: availableCameraController.cameras,
      builder: (context, snapshot) {
        debugPrint('In TakePictureScreen ${index}');
        if (snapshot.hasData) {
          return _TakePictureBody(camera: snapshot.data.first, index: this.index);
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class _TakePictureBody extends StatefulWidget {
  final CameraDescription camera;
  final int index;

  const _TakePictureBody({
    Key key,
    @required this.camera,
    @required this.index,
  }) : super(key: key);

  @override
  _TakePictureBodyState createState() => _TakePictureBodyState();
}

class _TakePictureBodyState extends State<_TakePictureBody> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  final StripController _stripController = Get.find();
  int index;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    debugPrint('In TakePicturebodyState ${widget.index}');
    index = widget.index;
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
      floatingActionButton: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FloatingActionButton(
              child: Icon(Icons.camera),
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  debugPrint('print me ${index}');
                  stdout.writeln('print me ${index}');
                  final image = await _controller.takePicture();
                  _stripController.updateItem(index, image.path);
                } catch (e) {
                  print(e);
                }
                Get.to(StripScreen());
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
