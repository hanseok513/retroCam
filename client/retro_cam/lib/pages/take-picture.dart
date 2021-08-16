import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retro_cam/components/navbar.dart';
import 'package:image_picker/image_picker.dart';

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
  double exposurePoint;

  @override
  void initState() {
    super.initState();
    _controllers =
        widget.cameras.map((cd) => CameraController(cd, ResolutionPreset.medium)).toList();
    isAltnativeCamera = true;
    exposurePoint = 0.0;
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
    // CameraController currentController = _controllers[isAltnativeCamera ? 1 : 0];
    Future<CameraController> currentController = () async {
      final controller = _controllers[isAltnativeCamera ? 1 : 0];
      await controller.initialize();
      return controller;
    }();

    return Scaffold(
      body: FutureBuilder<CameraController>(
        future: currentController,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            CameraController controller = snapshot.data;
            return Container(
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SimpleNavBar(
                    title: '',
                    button: IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  Expanded(child: CameraPreviewControl(controller)),
                  Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(horizontal: 64),
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.circle, size: 48),
                          onPressed: () async {
                            final image =
                                await ImagePicker.platform.pickImage(source: ImageSource.gallery);
                            // TODO(hanseok): What should we do with this image?
                          },
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 16, 16),
                          child: IconButton(
                            alignment: Alignment.center,
                            icon: Icon(Icons.circle, size: 64),
                            onPressed: () async {
                              try {
                                Directory appDocDir = await getApplicationDocumentsDirectory();
                                final imageFile = await controller.takePicture();
                                Get.back(result: imageFile.path);
                              } catch (e) {
                                print(e);
                                Get.back();
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.flip_camera_android_outlined, size: 48),
                          onPressed: () => setState(() => {isAltnativeCamera = !isAltnativeCamera}),
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

class CameraPreviewControl extends StatefulWidget {
  final CameraController controller;
  CameraPreviewControl(this.controller);

  @override
  CameraPreviewControlState createState() => CameraPreviewControlState();
}

Future<List<double>> getExposureOffsetRange(CameraController controller) async {
  final min = await controller.getMinExposureOffset();
  final max = await controller.getMaxExposureOffset();
  return [min, max];
}

class CameraPreviewControlState extends State<CameraPreviewControl> {
  double exposureOffset;
  Future<List<double>> exposureOffsetRange;

  @override
  void initState() {
    super.initState();
    exposureOffset = 0.0;
    exposureOffsetRange = getExposureOffsetRange(widget.controller);
  }

  @override
  Widget build(BuildContext build) {
    widget.controller.setExposureOffset(exposureOffset);
    return FutureBuilder<List<double>>(
      future: exposureOffsetRange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          final min = snapshot.data[0];
          final max = snapshot.data[1];
          return Column(
            children: [
              Expanded(
                child: CameraPreview(
                  widget.controller,
                ),
              ),
              Container(
                width: 200,
                child: SliderTheme(
                  data: SliderThemeData(
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 2,
                  ),
                  child: Slider(
                    activeColor: Colors.white,
                    value: exposureOffset,
                    min: min,
                    max: max,
                    onChanged: (double newValue) {
                      setState(() {
                        this.exposureOffset = newValue;
                      });
                    },
                  ),
                ),
              )
            ],
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
