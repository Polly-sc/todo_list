import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'groups_list/group_list.dart';
import 'navigation/main_navigation.dart';

class ToDoListPage extends StatelessWidget {
  final ScreenFactory screenFactory;

  ToDoListPage({required this.screenFactory});

  Widget TopLeftWidget(double screenWidth) {
    return Transform.rotate(
      angle: -35 * math.pi / 180,
      child: Container(
        width: 0.7 * screenWidth,
        height: 0.7 * screenWidth,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
              radius: 2,
              // center: Alignment(20, 20),
              focal: Alignment.centerRight,
              // focalRadius: ,
              colors: [
                Color.fromRGBO(100, 111, 212, 1),
                Color.fromRGBO(153, 160, 227, 0.7),
                Color.fromRGBO(255, 255, 255, 0.5),
              ],
              stops: [0.29, 0.5, 0.7,]
          ),
        ),
      ),
    );
  }

  Widget TopRigthWidget(double screenWidth) {
    return Container(
      width: 1 * screenWidth,
      height: 2 * screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(225, 300)),
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [
            0.1,
            0.5,
            0.85,
          ],
          colors: [
            Color.fromRGBO(100, 111, 212, 0),
            Color.fromRGBO(100, 111, 212, 0.81),
            Color.fromRGBO(100, 111, 212, 1),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(100, 111, 212, 1),
        toolbarHeight: 0,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: -190,
              left: 100,
              child: TopRigthWidget(screenSize.width),
            ),
            Positioned(
              top: -70,
              left: -40,
              child: TopLeftWidget(screenSize.width),
            ),
            screenFactory.makeGroupList(),
            // GroupList(screenFactory: ScreenFactory.this),
          ],
        ),
      ),
    );
  }
}