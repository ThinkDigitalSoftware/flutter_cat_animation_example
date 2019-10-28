import 'dart:math';

import 'package:animation/src/widgets/cat.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();
    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );

    boxController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    boxAnimation = Tween(begin: pi * 0.53, end: pi * 0.55).animate(
      CurvedAnimation(
        curve: Curves.easeInOut,
        parent: boxController,
      ),
    );
    catAnimation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        boxController.repeat(reverse: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation Example'),
        centerTitle: true,
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap()
            ],
            overflow: Overflow.visible,
          ),
        ),
        onTap: () {
          if (catController.status == AnimationStatus.completed) {
            boxController.forward();
            catController.reverse();
          } else if (catIsInTheBox) {
            catController.forward();
            boxController.stop();
          }
        },
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          left: 0,
          right: 0,
        );
      },
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (BuildContext context, Widget child) {
          return Transform.rotate(angle: _catAngle, child: child);
        },
        child: Cat(),
      ),
    );
  }

  bool get catIsInTheBox => catController.status == AnimationStatus.dismissed;

  double get _catAngle {
    if (catIsInTheBox) {
      return boxAnimation.value * 0.3 - 0.5;
    }
    return 0;
  }

  buildBox() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(color: Colors.brown, border: Border.all()),
      child: Center(
        child: Text(
          "Click me!",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  buildLeftFlap() {
    return Positioned(
      left: 3.0,
      top: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: boxAnimation.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
        child: Container(
          color: Colors.brown,
          height: 10,
          width: 125,
        ),
      ),
    );
  }

  buildRightFlap() {
    return Positioned(
      right: 3.0,
      top: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: -boxAnimation.value,
            alignment: Alignment.topRight,
            child: child,
          );
        },
        child: Container(
          color: Colors.brown,
          height: 10,
          width: 125,
        ),
      ),
    );
  }

  double angleInDegrees(double degrees) {
    const degree = pi / 2.0 / 90;
    return degree * degrees;
  }
}
