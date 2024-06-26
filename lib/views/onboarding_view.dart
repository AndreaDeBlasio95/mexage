import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_widgets/onboarding_page.dart';

class OnboardingView extends StatefulWidget {
  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      'title': 'Explore anonymity with SeaBottle!',
      'description': 'Description 1',
      'image': 'images/icon-onboard-1.png',
    },
    {
      'title': 'Send an anonymous message daily.',
      'description': 'Description 2',
      'image': 'images/icon-send-message.png',
    },
    {
      'title': 'Messages delivered at dawn to random users.',
      'description': 'Description 3',
      'image': 'images/icon-sea-bottle.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    //loadSharedPrefs();
  }

  void loadSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? onboarding = prefs.getBool('onboarding');
    if (onboarding != null && onboarding) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentPage <= 0) {
          return false;
        } else {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
          return false;
        }
      },
      child: Scaffold(
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
              onTap: () async {
                if (_currentPage == onboardingData.length -1) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('onboarding', true);
                  if (mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                } else if (_currentPage == onboardingData.length - 1) {
                  // Navigate to next screen or perform desired action
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.3),
                padding:
                    const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF7D53DE),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _currentPage == onboardingData.length - 1
                      ? 'Get Started'
                      : 'Next',
                  style: const TextStyle(
                    fontFamily: 'nunito',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontVariations: [
                      FontVariation('wght', 700),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 42),
          ],
        ),
      ),
    );
  }
}
