import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/onboarding_page.dart';
import '../theme/custom_themes.dart';

class OnboardingView extends StatefulWidget {
  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, String>> onboardingData = [
    {
      'title': 'Title 1',
      'description': 'Description 1',
      'image': 'images/icon-palm.png',
    },
    {
      'title': 'Title 2',
      'description': 'Description 2',
      'image': 'images/icon-palm.png',
    },
    {
      'title': 'Title 3',
      'description': 'Description 3',
      'image': 'images/icon-palm.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60),
            child: const Text(
              'SeaBottle',
              style: TextStyle(
                fontFamily: 'madami',
                color: Color(0xFF7D53DE),
                fontWeight: FontWeight.bold,
                fontSize: 42,
                fontVariations: [
                  FontVariation('wght', 700),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingPage(
                  title: onboardingData[index]['title']!,
                  description: onboardingData[index]['description']!,
                  image: onboardingData[index]['image']!,
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 10,
                width: _currentPage == index ? 30 : 10,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          GestureDetector(
            onTap: () {
              if (_currentPage == onboardingData.length - 1) {
                // Navigate to next screen or perform desired action
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3),
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Color(0xFF7D53DE),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _currentPage == onboardingData.length - 1
                    ? 'Get Started'
                    : 'Next',
                style: TextStyle(
                  fontFamily: 'nunito',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontVariations: [
                    FontVariation('wght', 700),
                  ],
                ), textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 42),
        ],
      ),
    );
  }
}
