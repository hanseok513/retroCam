import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retro_cam/pages/home.dart';
import 'package:retro_cam/pages/take-picture.dart';

class StripScreen extends StatelessWidget {
  final StripController stripController = Get.put(StripController(4));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Container(
          margin: EdgeInsets.all(38),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () => {},
                        ),
                        IconButton(
                          icon: Icon(Icons.file_download, color: Colors.white),
                          onPressed: () => {},
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () => Get.to(HomeScreen()),
                  ),
                ],
              ),
              Column(
                children: List.from(
                  stripController.items.asMap().entries.map(
                        (entry) => StripItem(
                          index: entry.key,
                          imagePath: entry.value,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StripController extends GetxController {
  List<String> items;

  updateItem(int index, String imagePath) {
    this.items[index] = imagePath;
  }

  StripController(int count) {
    this.items = List.filled(count, '');
  }
}

class StripItem extends StatelessWidget {
  final String imagePath;
  final int index;
  StripController controller = Get.find();

  StripItem({Key key, this.imagePath, this.index}) : super(key: key);

  @override
  Widget build(BuildContext build) {
    return Container(
      child: TextButton(
        onPressed: () => {Get.to(TakePictureScreen(index: this.index))},
        child: this.imagePath == ''
            ? Image(
                image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
              )
            : Image.file(
                File(this.imagePath),
              ),
      ),
    );
  }
}
