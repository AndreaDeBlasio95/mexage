import 'package:flutter/material.dart';
import 'package:mexage/theme/custom_themes.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

    return Container(
      color: themeProvider.cBackGround,
      child: DefaultTabController(
        length: 2, // The number of tabs / views.
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeProvider.cBackGround,
            title: Row(
              children: [
                Text(
                  'Mexage',
                  style: themeProvider.tTextAppBar,
                ),
                Image.asset(
                  'assets/images/icon-mexage-white.png',
                  height: 40,
                  width: 40,
                ),
              ],
            ),
            bottom: TabBar(
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
                Center(child: Text('Received', style: themeProvider.tTextBold)),
                Center(child: Text('Sent', style: themeProvider.tTextBold)),
              ],
            ),
          ),
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
        ),
      ),

    );
  }
}
