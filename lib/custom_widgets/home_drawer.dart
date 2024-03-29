import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sign_in_provider.dart';
import '../providers/user_provider.dart';
import '../theme/custom_themes.dart';

class CustomDrawer extends StatefulWidget {
  final Function(int) onThemeChange;
  final int? themeColorSelected;

  const CustomDrawer({super.key, required this.onThemeChange, required this.themeColorSelected});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  int? themeColorSelected; // Default theme index
  String? userName = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkTheme());
    //getUserName();
  }

  void checkTheme() {
    themeColorSelected = widget.themeColorSelected;
    if (themeColorSelected == null) {
      setTheme(0);
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
    themeColorSelected ??= widget.themeColorSelected;
    final SignInProvider _signInProvider = Provider.of<SignInProvider>(context, listen: false);
    final UserProvider _userProvider = Provider.of<UserProvider>(context, listen: false);

    return Drawer(
      backgroundColor: themeProvider.cBackGround,
      child: ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          // Profile
          const SizedBox(height: 24),
          Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text("Profile", style: themeProvider.tTextTitleDrawer)),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: themeProvider.cCardDrawer,
            child: ListTile(
              leading: Icon(Icons.person, color: themeProvider.cIcons),
              title: Text(_userProvider.userName, style: themeProvider.tTextMessageCardDrawer, overflow: TextOverflow.ellipsis,),
              onTap: () {
                // Handle the tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
          Card(
            elevation: 0,
            color: themeProvider.cCardDrawer,
            child: ListTile(
              leading: Icon(Icons.email, color: themeProvider.cIcons),
              title: Text('${_signInProvider.currentUser!.email}', style: themeProvider.tTextMessageCardDrawer, overflow: TextOverflow.ellipsis,),
              onTap: () {
                // Handle the tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
          // end profile
          // Settings
          const SizedBox(height: 24),
          Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text("Settings", style: themeProvider.tTextTitleDrawer)
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: themeProvider.cCardDrawer,
            child: ListTile(
              leading: Icon(Icons.notifications, color: themeProvider.cIcons),
              title: Text('Notifications', style: themeProvider.tTextMessageCardDrawer),
              onTap: () {
                // Handle the tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
          Card(
            elevation: 0,
            color: themeProvider.cCardDrawer,
            child: ListTile(
              leading: Icon(Icons.security, color: themeProvider.cIcons),
              title: Text('Security', style: themeProvider.tTextMessageCardDrawer),
              onTap: () {
                // Handle the tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
          Card(
            elevation: 0,
            color: themeProvider.cCardDrawer,
            child: ListTile(
              leading: themeColorSelected == 0 ? Icon(Icons.light_mode, color: themeProvider.cIcons) : Icon(Icons.dark_mode, color: themeProvider.cIcons),
              title: Text('Switch Theme', style: themeProvider.tTextMessageCardDrawer),
              onTap: () {
                // Handle the tap
                if (themeColorSelected == 0) {
                  setTheme(1);
                  widget.onThemeChange(1); // Use the callback with the new theme value
                } else {
                  setTheme(0);
                  widget.onThemeChange(0); // Use the callback with the new theme value
                }
              },
            ),
          ),
          // end theme
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          // Logout
          const SizedBox(height: 24),
          Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text("Logout", style: themeProvider.tTextTitleDrawer)
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: themeProvider.cRed,
            child: ListTile(
              leading: themeColorSelected == 0 ? Icon(Icons.logout_rounded, color: Colors.white) : Icon(Icons.logout_rounded, color: Colors.white),
              title: Text('Logout', style: themeProvider.tTextMessageCardDrawer),
              onTap: () async {
                await _signInProvider.handleSignOut();
                if (mounted){
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ),
          // end theme
        ],
      ),
    );
  }
}
