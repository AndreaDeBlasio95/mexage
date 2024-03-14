import 'package:flutter/material.dart';
import 'package:mexage/views/home_view.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkTheme());
  }

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
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Container(
                child: Image.asset(
                  'images/icon-mexage.png',
                  height: 200,
                  width: 200,
                  color: themeProvider.cTextAppBar,
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
                height: MediaQuery.of(context).size.height * 0.11,
              ),
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
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    marginValueRegisterNow = 0;
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
                        title: Text("Register Now",
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
            ],
          ),
        ),
      ),
    );
  }
}
