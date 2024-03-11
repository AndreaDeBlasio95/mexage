import 'package:flutter/material.dart';
import 'package:mexage/theme/custom_themes.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int? themeColorSelected;     // 0 for light, 1 for dark

  @override
  void initState() {
    super.initState();
    checkTheme(); // set the theme color
  }

  void checkTheme() {
    if (themeColorSelected == null) {
      themeColorSelected = 1;
      Provider.of<CustomThemes>(context, listen: false).setTheme(1);
    } else {
      Provider.of<CustomThemes>(context, listen: false).setTheme(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Provider.of<CustomThemes>(context, listen: false);

    return Container(
      color: themeColor.cBackGround,
      child: DefaultTabController(
        length: 2, // The number of tabs / views.
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeColor.cBackGround,
            title: const Text('Tab View Example', ),
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.chat), text: 'Chat'),
                Tab(icon: Icon(Icons.settings), text: 'Settings'),
              ],
            ),
          ),
          body: Container(
            color: themeColor.cBackGround,
            child: TabBarView(
              children: [
                // The views for each tab.
                const Center(child: Text('Chat')),
                const Center(child: Text('Settings')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
