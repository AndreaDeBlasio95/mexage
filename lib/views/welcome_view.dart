import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../theme/custom_themes.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  int? themeColorSelected; // 0 for light, 1 for dark
  double marginValueOpenBottle = 6;
  double marginValueRegisterNow = 6;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkTheme());

    // Listen to the auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        // Perform actions if the user is signed out
      } else {
        print('User is signed in!');
        Navigator.pushNamed(context, '/home');
        // Perform actions if the user is signed in, such as redirecting to a home screen
      }
    });
  }


  Future<User?> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(credential);
        final User? user = authResult.user;


        setState(() {
          marginValueRegisterNow = 6;
          marginValueOpenBottle = 6;
        });
        print("User Name: ${user!.displayName}");

        return user;
      } else {

        setState(() {
          marginValueRegisterNow = 6;
          marginValueOpenBottle = 6;
        });
        print("User cancelled the login");

        return null;
      }
    } catch (error) {

      setState(() {
        marginValueRegisterNow = 6;
        marginValueOpenBottle = 6;
      });
      print("Error signing in with Google: $error");
      return null;
    }
  }


  Future<void> _handleSignOut() async {
    try {
      await googleSignIn.signOut();
      await _auth.signOut();
      print("User signed out successfully");
    } catch (error) {
      print("Error signing out: $error");
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

  void setTheme(int _value) {
    setState(() {
      themeColorSelected = _value;
    });
    Provider.of<CustomThemes>(context, listen: false).setTheme(_value);
  }

  void updateTheme(int value) {
    setState(() {
      themeColorSelected = value; // Update the theme or state based on value
    });
  }
  // end theme ---
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return Scaffold(
      backgroundColor: themeProvider.cBackGround,
      body: SingleChildScrollView(
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
              Text(
                'SeaBottle',
                style: themeProvider.tTextWelcomeTitle,
              ),
              const SizedBox(height: 20),
              Text(
                'Send and receive messages in a bottle.',
                style: themeProvider.tTextTitleDrawer,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.15  ,
              ),
              // Login
              /*
              GestureDetector(
                onTap: () {
                  setState(() {
                    marginValueOpenBottle = 0;
                  });
                  Navigator.pushNamed(context, '/home');
                },
                onLongPressStart: (_) {
                  setState(() {
                    marginValueOpenBottle = 0;
                  });
                },
                onLongPressEnd: (_) {
                  setState(() {
                    marginValueOpenBottle = 6;
                  });
                },
                child: Container(
                  margin: marginValueOpenBottle > 0 ? const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 0) : const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 6),
                  decoration: BoxDecoration(
                    color: themeProvider.cCardShadow,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    margin: marginValueOpenBottle > 0 ? const EdgeInsets.only(bottom: 6) : const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: themeProvider.cCardMessageInbox,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 16),
                      child: ListTile(
                        title: Text("Open a Bottle!",
                            style: themeProvider.tTextBoldMedium,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              ),

               */
              const SizedBox(height: 8),
              // Sign In With Google -----
              GestureDetector(
                onTap: () async {
                  setState(() async {
                    marginValueRegisterNow = 0;
                    User? _user = await _handleSignIn();
                    if (mounted && _user != null) {
                      Navigator.pushNamed(context, '/home');
                    }
                  });
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
                  margin: marginValueRegisterNow > 0 ? const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 0) : const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 6),
                  decoration: BoxDecoration(
                    color: themeProvider.cCardMessageInbox,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    margin: marginValueRegisterNow > 0 ? const EdgeInsets.only(left: 2, right: 2, top: 1, bottom: 6) : const EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
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
                        title: Text("Sign in with Google!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: themeProvider.cCardMessageInbox),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              ),
              // Sign Out -----
              /*
              GestureDetector(
                onTap: () {
                  _handleSignOut();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 6),
                  decoration: BoxDecoration(
                    color: themeProvider.cCardMessageInbox,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 2, right: 2, top: 1, bottom: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
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
                        title: Text("Sign out",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: themeProvider.cCardMessageInbox),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              ),
               */
            ],
          ),
        ),
      ),
    );
  }
}
