import 'dart:ui';

import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'nunito',
              color: Color(0xFF121212),
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontVariations: [
                FontVariation('wght', 700),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Image.asset(image, height: 200),
        ],
      ),
    );
  }
}
