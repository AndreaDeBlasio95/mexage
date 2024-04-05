import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mexage/providers/sign_in_provider.dart';
import 'package:mexage/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../theme/custom_themes.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  bool _isLoading = true;
  int themeColorSelected = 0; // 0 for light, 1 for dark
  double marginValueOpenBottle = 6;
  double marginValueRegisterNow = 6;

  @override
  void initState() {
    super.initState();
    isUserLogged();
  }

  Future<void> isUserLogged() async {
    final SignInProvider _signInProvider =
        Provider.of<SignInProvider>(context, listen: false);
    bool isLogged = await _signInProvider.isUserLoggedIn();
    if (isLogged) {
      if (mounted) {
        Navigator.pushNamed(context, '/home');
      }
    } else {
      setState(() {
        _isLoading = false;
        //checkTheme();
      });
    }
  }

  // theme ---
  void checkTheme() {
    themeColorSelected =
        Provider.of<CustomThemes>(context, listen: false).currentTheme;

    if (themeColorSelected == null) {
      setState(() {
        themeColorSelected = 1;
      });
      Provider.of<CustomThemes>(context, listen: false).setTheme(1);
    } else {
      setState(() {
        themeColorSelected = 0;
      });
      Provider.of<CustomThemes>(context, listen: false).setTheme(0);
    }
  }

  // end theme ---
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);
    final SignInProvider _signInProvider =
        Provider.of<SignInProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? Container()
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Container(
                        child: Image.asset(
                          'images/icon-sea-bottle.png',
                          height: 200,
                          width: 200,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'SeaBottle',
                        style: TextStyle(
                          fontFamily: 'madami',
                          color: Color(0xFF4259F0),
                          fontWeight: FontWeight.w900,
                          fontSize: 36,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 42),
                        child: const Text(
                          'Send and receive messages in a bottle.',
                          style: TextStyle(
                            fontFamily: 'nunito',
                            color: Color(0xFF454F54),
                            fontSize: 18,
                            fontVariations: [
                              FontVariation('wght', 700),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.13,
                      ),
                      const SizedBox(height: 8),
                      // Sign In With Google -----
                      GestureDetector(
                        onTap: () async {
                          marginValueRegisterNow = 0;
                          User? _user = await _signInProvider.handleSignIn();
                          UserProvider _userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          if (_user != null) {
                            _userProvider.registerOrGetUser(context);
                          }
                          if (mounted && _user != null) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        onLongPressStart: (_) {
                          setState(() {
                            marginValueRegisterNow = 0;
                          });
                        },
                        onLongPressEnd: (_) {
                          setState(() {
                            marginValueRegisterNow = 6;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 8, top: 0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1AADF6),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1AADF6).withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: const Color(0xFF1AADF6).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Card(
                              elevation: 0,
                              color: Colors.transparent,
                              margin: const EdgeInsets.only(
                                  top: 4, bottom: 4, left: 16, right: 16),
                              child: ListTile(
                                leading: Image.asset(
                                  'images/icon-google.png',
                                  height: 28,
                                  width: 28,
                                ),
                                title: const Text("Sign in with Google!",
                                    style: TextStyle(
                                      fontFamily: 'nunito',
                                      color: Color(0xFF141F23),
                                      fontSize: 18,
                                      fontVariations: [
                                        FontVariation('wght', 800),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
