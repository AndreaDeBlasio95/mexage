import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mexage/custom_widgets/animated_cartoon_container_new.dart';
import 'package:mexage/custom_widgets/custom_snack_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/sign_in_provider.dart';
import '../providers/user_provider.dart';
import '../theme/custom_themes.dart';
import '../utils/utils.dart';

class CustomDrawer extends StatefulWidget {
  final Function(int) onThemeChange;
  final int? themeColorSelected;

  const CustomDrawer(
      {super.key,
      required this.onThemeChange,
      required this.themeColorSelected});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int? themeColorSelected; // Default theme index
  String? userName = "";
  double paddingVerticalRow = 4.0;
  String notificationStatus = "Off";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkTheme());
    loadNotificationPermissionStatus();
  }

  // Load the notification permission status
  void loadNotificationPermissionStatus() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      // If permission is granted, set the switch to on
      setState(() {
        notificationStatus = "On";
      });
    } else {
      // If permission is not granted, keep the switch off
      setState(() {
        notificationStatus = "Off";
      });
    }
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

  Future<void> printH() async {
    print("Hello");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<CustomThemes>(context, listen: false);
    themeColorSelected ??= widget.themeColorSelected;
    final SignInProvider _signInProvider =
        Provider.of<SignInProvider>(context, listen: false);
    final UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Drawer(
      backgroundColor: themeProvider.cBackGround,
      child: ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          // Profile
          const SizedBox(height: 24),
          Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text("Account", style: themeProvider.tTextTitleDrawer)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeProvider.cIcons,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                // nickname
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await Clipboard.setData(
                        ClipboardData(text: _userProvider.userName));
                    if (mounted) {
                      CustomSnackBar.showSnackbar(
                          context, "Username copied", themeProvider);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: paddingVerticalRow),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Icon(Icons.person, color: themeProvider.cIcons),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            _userProvider.userName,
                            style: themeProvider.tTextDrawer,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 1,
                  color: themeProvider.cIcons,
                ),
                const SizedBox(height: 8),
                // email
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await Clipboard.setData(
                        ClipboardData(text: "${_signInProvider.currentUser!.email}"));
                    if (mounted) {
                      CustomSnackBar.showSnackbar(
                          context, "Email copied", themeProvider);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: paddingVerticalRow),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Icon(Icons.email_rounded, color: themeProvider.cIcons),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            "${_signInProvider.currentUser!.email}",
                            style: themeProvider.tTextDrawer,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // end profile
          // Settings
          const SizedBox(height: 24),
          Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text("Settings", style: themeProvider.tTextTitleDrawer)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeProvider.cIcons,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                // nickname
                Container(
                  padding: EdgeInsets.symmetric(vertical: paddingVerticalRow),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      Icon(Icons.notifications, color: themeProvider.cIcons),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Notification",
                          style: themeProvider.tTextDrawer,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          notificationStatus,
                          style: themeProvider.tTextTimestamp,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 1,
                  color: themeProvider.cIcons,
                ),
                const SizedBox(height: 8),
                // email
                InkWell(
                  onTap: ()  {
                    Navigator.pushNamed(context, '/privacy-policy');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: paddingVerticalRow),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Icon(Icons.security_rounded, color: themeProvider.cIcons),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            "Security",
                            style: themeProvider.tTextDrawer,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 1,
                  color: themeProvider.cIcons,
                ),
                const SizedBox(height: 8),
                // email
                InkWell(
                  onTap: () {
                    // Handle the tap
                    if (themeColorSelected == 0) {
                      setTheme(1);
                      widget.onThemeChange(
                          1); // Use the callback with the new theme value
                    } else {
                      setTheme(0);
                      widget.onThemeChange(
                          0); // Use the callback with the new theme value
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: paddingVerticalRow),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        themeColorSelected == 0
                            ? Icon(Icons.light_mode,
                                color: themeProvider.cIcons)
                            : Icon(Icons.dark_mode,
                                color: themeProvider.cIcons),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Text(
                            "Switch Theme",
                            style: themeProvider.tTextDrawer,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // end theme
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          // Logout
          const SizedBox(height: 24),
          Container(
              padding: const EdgeInsets.only(left: 8),
              child: Text("Logout", style: themeProvider.tTextTitleDrawer)),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: themeProvider.cRed,
            child: ListTile(
              leading: themeColorSelected == 0
                  ? const Icon(Icons.logout_rounded, color: Colors.white)
                  : const Icon(Icons.logout_rounded, color: Colors.white),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'nunito',
                  color: Colors.grey.shade200,
                  fontSize: 18,
                  fontVariations: const [
                    FontVariation('wght', 700),
                  ],
                ),
              ),
              onTap: () async {
                await _signInProvider.handleSignOut();
                if (mounted) {
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
