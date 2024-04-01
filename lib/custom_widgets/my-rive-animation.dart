import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveAnimationBottle extends StatefulWidget {
  const RiveAnimationBottle({super.key});

  @override
  State<RiveAnimationBottle> createState() => _RiveAnimationBottleState();
}

class _RiveAnimationBottleState extends State<RiveAnimationBottle> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          width: 300,
        ),
        Container(
          height: 400,
          width: 400,
          child: RiveAnimation.asset(
            "animations/idle-loop-1.riv",
            artboard: 'New Artboard',
            animations: ['1 - Idle'],
            fit: BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }
}
