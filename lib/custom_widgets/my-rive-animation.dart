import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveAnimationBottle extends StatefulWidget {
  @override
  _RiveAnimationBottleState createState() => _RiveAnimationBottleState();
}

class _RiveAnimationBottleState extends State<RiveAnimationBottle> {
  late SimpleAnimation _controller;
  int _animationIndex = 0; // Track the current animation index

  @override
  void initState() {
    super.initState();
    // Initialize with the first animation
    _controller = SimpleAnimation('1 - Idle');
  }

  void _toggleAnimation() {
    setState(() {
      // Increment the animation index with each tap
      _animationIndex++;
      // Reset the index if it exceeds the number of animations
      if (_animationIndex > 3) _animationIndex = 0;

      // Determine the animation based on the current index
      switch (_animationIndex) {
        case 0:
          _controller = SimpleAnimation('1 - Idle');
          break;
        case 1:
          _controller = SimpleAnimation('2 - Solo Bottle');
          break;
        case 2:
          _controller = SimpleAnimation('3 - Open Bottle');
          break;
        case 3:
          _controller = SimpleAnimation('4 - Open Parchment');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAnimation, // Change animation on tap
      child: Stack(
        children: [
          Container(
            height: 400,
            width: 400,
            child: RiveAnimation.asset(
              "animations/animation-parchment.riv",
              artboard: 'New Artboard',
              controllers: [_controller], // Provide the current controller
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
