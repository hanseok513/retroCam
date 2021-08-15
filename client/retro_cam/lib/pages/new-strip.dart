import 'package:flutter/material.dart';
import 'package:retro_cam/components/simple-navbar.dart';
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
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: List.generate(
                    6,
                    (index) => Container(
                      margin: EdgeInsets.fromLTRB((index % 2) * 40.0, 350 - index * 70.0, 0, 0),
                      child: GestureDetector(
                        child: Container(
                          child: Image.asset(
                            'assets/box${index + 1}.webp',
                            height: 120,
                          ),
                        ),
                        onTap: () => Get.to(
                          StripScreen(
                            film: Film('edit title', [], 'assets/box${index + 1}.webp'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
