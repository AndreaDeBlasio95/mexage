import 'package:flutter/material.dart';
import 'package:mexage/theme/custom_themes.dart';
import 'package:mexage/views/board_view.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/home_drawer.dart';
import '../models/message_model.dart';
import 'inbox_view.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoading = true;
  int? themeColorSelected; // 0 for light, 1 for dark
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    BoardView(),
    Text('Search Page'),
    Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkTheme());
  }

  Future<void> checkTheme() async {
    if (mounted) {
      themeColorSelected =
          Provider.of<CustomThemes>(context, listen: false).currentTheme;

      if (themeColorSelected == null) {
        Provider.of<CustomThemes>(context, listen: false).setTheme(1);
      } else {
        Provider.of<CustomThemes>(context, listen: false).setTheme(0);
      }

      setState(() {
        _isLoading = false; // Data has finished loading
      });
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
      drawer: CustomDrawer(
        onThemeChange: updateTheme,
        themeColorSelected: themeColorSelected,
      ),
      // Use the custom drawer here
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
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: themeProvider.cBackGround,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_rounded),
              label: 'Received',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          iconSize: 24,
          selectedIconTheme: const IconThemeData(
            size: 28,
          ),
          selectedItemColor: themeProvider.cTextNavigationSelected,
          unselectedItemColor: themeProvider.cTextNavigationNotSelected,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
