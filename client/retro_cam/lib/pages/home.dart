import 'package:flutter/material.dart';
import 'package:retro_cam/pages/strip.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Retro Cam',
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => {Get.to(StripScreen())},
                    color: Colors.white,
                  )
                ],
              ),
            ),
            CansGrid()
          ],
        ),
      ),
    );
  }
}

class CansGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(38, 0, 38, 38),
        child: _buildCanGrid(),
      ),
    );
  }
}

List<Container> _buildGridTileList(int count) => List.generate(
      count,
      (index) => Container(
        color: Colors.white,
        child: SizedBox(
          height: 100,
          child: Icon(
            Icons.umbrella,
            size: 50,
          ),
        ),
      ),
    );

Widget _buildCanGrid() => GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridTileList(10),
    );
