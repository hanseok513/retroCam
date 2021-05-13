import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_cam/pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CameraState>(
          create: (context) => CameraState(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class CameraState extends ChangeNotifier {
  Future<List<CameraDescription>> _cameraDescription;
  CameraState() {
    _cameraDescription = availableCameras();
  }

  Future<List<CameraDescription>> get cameras {
    return _cameraDescription;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RetroCam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
