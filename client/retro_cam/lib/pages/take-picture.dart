import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';

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
  final AvailableCameraController availableCameraController = Get.put(AvailableCameraController());
  TakePictureScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: availableCameraController.cameras,
      builder: (context, snapshot) {
        List<CameraDescription> data = snapshot.data;
        if (data != null) {
          return _TakePictureBody(cameras: data);
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class _TakePictureBody extends StatefulWidget {
  final List<CameraDescription> cameras;

  const _TakePictureBody({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  @override
  _TakePictureBodyState createState() => _TakePictureBodyState();
}

class _TakePictureBodyState extends State<_TakePictureBody> {
  List<CameraController> _controllers;
  bool isAltnativeCamera;

  @override
  void initState() {
    super.initState();
    _controllers =
        widget.cameras.map((cd) => CameraController(cd, ResolutionPreset.medium)).toList();
    isAltnativeCamera = true;
  }

  @override
  void dispose() {
    _controllers.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CameraController currentController = _controllers[isAltnativeCamera ? 1 : 0];
    Future<void> _initializeControllerFuture = currentController.initialize();

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && _controllers != null) {
            return Container(
              child: Column(
                children: [
                  Expanded(
                    child: new Stack(
                      alignment: FractionalOffset.center,
                      children: <Widget>[
                        new Positioned.fill(
                          child: new AspectRatio(
                            aspectRatio: 1.0,
                            child: new Positioned.fill(
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return LinearGradient(
                                    colors: <Color>[Colors.yellow, Colors.yellow],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.color,
                                child: new CameraPreview(
                                  currentController,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.camera_alt, size: 64),
                          onPressed: () => setState(() => {isAltnativeCamera = !isAltnativeCamera}),
                        ),
                        IconButton(
                          icon: Icon(Icons.camera, size: 64),
                          onPressed: () async {
                            try {
                              await _initializeControllerFuture;
                              Directory appDocDir = await getApplicationDocumentsDirectory();
                              final imageFile = await currentController.takePicture();
                              Get.back(result: imageFile.path);
                            } catch (e) {
                              print(e);
                              Get.back();
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
