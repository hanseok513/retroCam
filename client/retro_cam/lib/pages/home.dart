import 'dart:io';

import 'package:flutter/material.dart';
import 'package:retro_cam/models/film.dart';
import 'package:retro_cam/pages/new-strip.dart';
import 'package:retro_cam/pages/strip.dart';
import 'package:get/get.dart';

class FilmsController extends GetxController {
  Future<List<Film>> films;

  FilmsController() {
    films = DatabaseHelper.instance.queryAllFilms();
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 90,
              margin: EdgeInsets.fromLTRB(38, 38, 38, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Retro Cam',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => {Get.to(NewStripScreen())},
                    color: Colors.white,
                  )
                ],
              ),
            ),
            CansGrid(onItemClick: (film) => Get.to(StripScreen(film: film)))
          ],
        ),
      ),
    );
  }
}

class CansGrid extends StatefulWidget {
  final FilmsController controller = Get.put(FilmsController());
  final void Function(Film) onItemClick;

  CansGrid({Key key, this.onItemClick});

  @override
  State<StatefulWidget> createState() => CansGridState();
}

class CansGridState extends State<CansGrid> {
  Future<List<Film>> films;
  @override
  void initState() {
    super.initState();
    films = DatabaseHelper.instance.queryAllFilms();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Film>>(
      future: films,
      builder: (context, snapshot) {
        List<Film> currentFilms = snapshot.data;
        Function(Film) onItemClick = widget.onItemClick;

        return Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(38, 10, 38, 38),
            child: (currentFilms != null && onItemClick != null)
                ? _buildCanGrid(currentFilms, onItemClick)
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No Film detected.'),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

List<Container> _buildGridTileList(
        List<Film> films, void Function(Film) onItemClick) =>
    films.map((film) {
      debugPrint(film.imagePaths[0]);
      return Container(
        child: GestureDetector(
          onTap: () => onItemClick(film),
          child: FittedBox(
            child: Image.asset(film.canImagePath),
            fit: BoxFit.fitHeight,
          ),
        ),
      );
    }).toList();

Widget _buildCanGrid(List<Film> films, void Function(Film) onItemClick) =>
    GridView.count(
      padding: const EdgeInsets.all(10),
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 60,
      children: _buildGridTileList(films, onItemClick),
    );
