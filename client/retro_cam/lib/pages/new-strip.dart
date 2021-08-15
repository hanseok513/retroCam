import 'package:flutter/material.dart';
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
            Container(
              height: 80,
              margin: EdgeInsets.all(38),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Select',
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => {Get.to(HomeScreen())},
                    color: Colors.white,
                  )
                ],
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
                      margin: EdgeInsets.fromLTRB(
                          (index % 2) * 40.0, 450 - index * 85.0, 0, 0),
                      child: GestureDetector(
                        child: Container(
                          height: 130,
                          child: Image.asset(
                            'assets/box${index + 1}.webp',
                            //height: 140,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        onTap: () => Get.to(
                          StripScreen(
                            film: Film('edit title', [],
                                'assets/box${index + 1}.webp'),
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
