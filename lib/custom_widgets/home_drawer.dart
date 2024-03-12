import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/custom_themes.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);

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
            color: themeProvider.cCardMessageInbox,
            child: ListTile(
              leading: Icon(Icons.person, color: themeProvider.cIcons),
              title: Text('Nickname', style: themeProvider.tTextNormal),
              onTap: () {
                // Handle the tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
          Card(
            elevation: 0,
            color: themeProvider.cCardMessageInbox,
            child: ListTile(
              leading: Icon(Icons.email, color: themeProvider.cIcons),
              title: Text('Email', style: themeProvider.tTextNormal),
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
            color: themeProvider.cCardMessageInbox,
            child: ListTile(
              leading: Icon(Icons.settings, color: themeProvider.cIcons),
              title: Text('Theme', style: themeProvider.tTextNormal),
              onTap: () {
                // Handle the tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
          Card(
            elevation: 0,
            color: themeProvider.cCardMessageInbox,
            child: ListTile(
              leading: Icon(Icons.notifications, color: themeProvider.cIcons),
              title: Text('Notifications', style: themeProvider.tTextNormal),
              onTap: () {
                // Handle the tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
          Card(
            elevation: 0,
            color: themeProvider.cCardMessageInbox,
            child: ListTile(
              leading: Icon(Icons.security, color: themeProvider.cIcons),
              title: Text('Security', style: themeProvider.tTextNormal),
              onTap: () {
                // Handle the tap
                Navigator.pop(context); // Close the drawer
              },
            ),
          ),
          // end settings
        ],
      ),
    );
  }
}
