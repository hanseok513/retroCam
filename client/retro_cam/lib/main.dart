import 'dart:async';

import 'package:camera/camera.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_cam/config/application.dart';
import 'package:retro_cam/config/routes.dart';
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
      child: App(),
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

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  AppState() {
    final router = FluroRouter();
    Routes.configureRoutes(router);
    Application.router = router;
  }

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
