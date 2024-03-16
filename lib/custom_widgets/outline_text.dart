import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color outlineColor;
  final double outlineWidth;

  const OutlinedText({super.key,
    required this.text,
    this.textStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    this.outlineColor = Colors.black,
    this.outlineWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Draw text with outline
        Text(
          text,
          style: textStyle.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth
              ..color = outlineColor,
          ),
        ),
        // Draw solid text on top
        Text(
          text,
          style: textStyle,
        ),
      ],
    );
  }
}