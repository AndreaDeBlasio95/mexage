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
  int? themeColorSelected; // 0 for light, 1 for dark
  double marginValueOpenBottle = 6;
  double marginValueRegisterNow = 6;

  @override
  void initState() {
    super.initState();
    isUserLogged();
    /*
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

     */

    //WidgetsBinding.instance.addPostFrameCallback((_) => checkTheme());
  }
  Future<void> isUserLogged () async {
    final SignInProvider _signInProvider = Provider.of<SignInProvider>(context, listen: false);
    bool isLogged = await _signInProvider.isUserLoggedIn();
    if (isLogged) {
      if (mounted) {
        Navigator.pushNamed(context, '/home');
      }
    } else {
      setState(() {
        _isLoading = false;
        checkTheme();
      });
    }
  }
  /*
  Future<User?> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
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
*/
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
    final SignInProvider _signInProvider = Provider.of<SignInProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
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
                    Text(
                      'SeaBottle',
                      style: themeProvider.tTextWelcomeTitle,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 42),
                      child: Text(
                        'Send and receive messages in a bottle.',
                        style: themeProvider.tTextMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.13,
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
                          User? _user = await _signInProvider.handleSignIn();
                          UserProvider _userProvider = Provider.of<UserProvider>(context, listen: false);
                          if (_user != null) {
                            _userProvider.registerOrGetUser(context);
                          }
                          if (mounted && _user != null) {
                            Navigator.pushReplacementNamed(context, '/home');
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
                        margin: marginValueRegisterNow > 0
                            ? const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 0)
                            : const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 6),
                        decoration: BoxDecoration(
                          color: themeProvider.cOutlineBlue,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Container(
                          margin: marginValueRegisterNow > 0
                              ? const EdgeInsets.only(
                                  left: 2, right: 2, top: 1, bottom: 6)
                              : const EdgeInsets.only(bottom: 0),
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
