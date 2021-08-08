import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:retro_cam/components/image-box.dart';
import 'package:retro_cam/models/film.dart';
import 'package:retro_cam/pages/home.dart';
import 'package:retro_cam/pages/take-picture.dart';

class StripScreen extends StatefulWidget {
  Film film;

  StripScreen({Key key, this.film}) : super(key: key);

  @override
  StripScreenState createState() => StripScreenState();
}

class StripScreenState extends State<StripScreen> {
  Film film;

  @override
  void initState() {
    super.initState();

    List<String> imagePaths = widget.film.imagePaths;
    imagePaths.addAllIf(imagePaths.length < 4, List.filled(4 - imagePaths.length, ''));
    film = widget.film;
  }

  @override
  void dispose() {
    super.dispose();
  }

  static Route<Object> _dialogBuilder(BuildContext context, Object child) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => Dialog(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> imagePaths = this.film?.imagePaths;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Container(
          margin: EdgeInsets.all(38),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
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
                          onPressed: () async {
                            Film film = this.film;
                            if (film != null) {
                              DatabaseHelper.instance.insert(film);
                            }
                            Get.to(HomeScreen());
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        imagePaths != null
                            ? StripList(
                                imagePaths: imagePaths,
                                onItemClick: (imagePath, index) {
                                  setState(
                                    () {
                                      imagePaths[index] = imagePath;
                                    },
                                  );
                                },
                              )
                            : CircularProgressIndicator(),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    film.name,
                    style: TextStyle(fontSize: 28),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => new Dialog(
                        child: TextField(
                          autofocus: true,
                          onSubmitted: (data) => setState(() {
                            film = Film.withId(data, film.imagePaths, film.canImagePath, film.id);
                          }),
                        ),
                        backgroundColor: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StripList extends StatelessWidget {
  final List<String> imagePaths;
  final void Function(String, int) onItemClick;
  StripList({Key key, this.imagePaths, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext build) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          child: Image.asset(
            'assets/stripborder.webp',
            width: 223,
            height: 572,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(50, 2, 50, 1),
          child: Expanded(
            child: Column(
              children: List.from(
                this.imagePaths.asMap().entries.map(
                      (entry) => StripItem(
                        imagePath: entry.value,
                        updatePath: (imagePath) {
                          this.onItemClick(imagePath, entry.key);
                        },
                      ),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StripItem extends StatelessWidget {
  final String imagePath;
  final void Function(String) updatePath;

  StripItem({Key key, this.imagePath, this.updatePath}) : super(key: key);

  @override
  Widget build(BuildContext build) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () async {
          String updatedImagePath = await Get.to(TakePictureScreen());
          if (updatedImagePath != null) {
            this.updatePath(updatedImagePath);
          }
        },
        child: Stack(
          children: [
            CroppedImageBox(
              image: this.imagePath == ''
                  ? Image.asset('assets/emptystripitem.webp')
                  : Image.file(File(this.imagePath)),
              aspectRatio: 181 / 120,
            ),
            Container(
              height: 120,
              child: Center(
                child: this.imagePath == '' ? Icon(Icons.add) : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
