import 'package:flutter/material.dart';
import 'package:mexage/theme/custom_themes.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/home_drawer.dart';
import '../models/message_model.dart';
import 'inbox_view.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int? themeColorSelected; // 0 for light, 1 for dark

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkTheme());
  }

  void checkTheme() {
    themeColorSelected = Provider.of<CustomThemes>(context, listen: false).currentTheme;

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

    return Container(
      color: themeProvider.cBackGround,
      child: DefaultTabController(
        length: 2, // The number of tabs / views.
        child: Scaffold(
          backgroundColor: themeProvider.cBackGround,
          drawer: CustomDrawer(onThemeChange: updateTheme, themeColorSelected: themeColorSelected,), // Use the custom drawer here
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: themeProvider.cTextNormal,
            ),
            backgroundColor: themeProvider.cBackGround,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SeaBottle',
                  style: themeProvider.tTextAppBar,
                ),

                const SizedBox(width: 4),
                themeColorSelected == 1
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          'images/icon-sea-bottle-2.png',
                          fit: BoxFit.fitHeight,
                          color: themeProvider.cTextTitle,
                        ),
                      )
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          'images/icon-sea-bottle-2.png',
                          fit: BoxFit.fitHeight,
                          color: themeProvider.cTextTitle,
                        ),
                      ),
                const SizedBox(width: 50),
              ],
            ),
            bottom: TabBar(
              dividerColor: Colors.transparent,
              indicatorColor: themeProvider.cTextTabBar,
              tabs: [
                Tab(
                  child: Text(
                    'Inbox',
                    style: themeProvider.tTextTabBar,
                  ),
                ),
                Tab(
                  child: Text(
                    'Sent',
                    style: themeProvider.tTextTabBar,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            color: themeProvider.cBackGround,
            child: TabBarView(
              children: [
                // The views for each tab.
                InboxView(
                  messages: [
                    Message(
                      id: "1",
                      content: 'Hello, how are you?',
                      rank: 1,
                      ranked: false,
                      thumbUp: 0,
                    ),
                    Message(
                      id: "2",
                      content: 'I am doing well, thank you! This is a long message',
                      rank: 2,
                      ranked: true,
                      thumbUp: 1,
                    ),
                    Message(
                      id: "3",
                      content: 'Short message',
                      rank: 2,
                      ranked: true,
                      thumbUp: 2,
                    ),
                  ],
                ),
                Center(child: Text('Sent', style: themeProvider.tTextBold)),
              ],
            ),
          ),
          // Floating action button
          /*
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              int currentTheme = themeProvider.currentTheme;
              if (currentTheme == 0) {
                setTheme(1);
              } else {
                setTheme(0);
              }
            },
            child: const Icon(Icons.add),
          ),
           */
        ),
      ),
    );
  }
}
