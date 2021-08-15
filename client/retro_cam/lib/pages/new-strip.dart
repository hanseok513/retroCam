import 'package:flutter/material.dart';
import 'package:retro_cam/components/film-container.dart';
import 'package:retro_cam/components/navbar.dart';
import 'package:retro_cam/models/film.dart';
import 'package:retro_cam/pages/home.dart';
import 'package:retro_cam/pages/strip.dart';
import 'package:get/get.dart';

class NewStripScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          children: [
            SimpleNavBar(
              title: 'Select',
              button: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => {Get.to(HomeScreen())},
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(child: FilmContainerSelector(6), alignment: Alignment.center),
            )
          ],
        ),
      ),
    );
  }
}

// Adjust these values to align overlapped film containers.
final double filmContainerHeight = 120.0;
final double filmContainerOverlapHeight = 50.0;
final double oddFilmContainerOffsetX = 40.0;

class FilmContainerSelector extends StatelessWidget {
  final int availableContainerCount;

  FilmContainerSelector(this.availableContainerCount, {Key key});

  @override
  Widget build(BuildContext context) {
    final containerHeightWithoutOverlapped = filmContainerHeight - filmContainerOverlapHeight;
    final fullheightWithoutFirstContainer =
        (availableContainerCount - 1) * containerHeightWithoutOverlapped;
    final fullHeight = filmContainerHeight + fullheightWithoutFirstContainer;

    return Container(
      height: fullHeight,
      child: Stack(
        children: List.generate(6, (index) {
          var imagePath = 'assets/box${index + 1}.webp';
          return Container(
            margin: EdgeInsets.only(
              left: (index % 2) * oddFilmContainerOffsetX,
              top: fullheightWithoutFirstContainer - index * containerHeightWithoutOverlapped,
            ),
            child: FilmContainer(
              imagePath: imagePath,
              onClick: () => Get.to(
                StripScreen(
                  film: Film(defaultFilmTitle, [], imagePath),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
