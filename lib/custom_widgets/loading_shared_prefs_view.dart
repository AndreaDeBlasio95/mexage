import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingSharedPrefsView extends StatefulWidget {
  const LoadingSharedPrefsView({super.key});

  @override
  State<LoadingSharedPrefsView> createState() => _LoadingSharedPrefsViewState();
}

class _LoadingSharedPrefsViewState extends State<LoadingSharedPrefsView> {

  @override
  void initState() {
    super.initState();
    loadSharedPrefs();
  }

  void loadSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? onboarding = prefs.getBool('onboarding');
    if (onboarding != null && onboarding) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboard');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
        ),
      ),
    );
  }
}
