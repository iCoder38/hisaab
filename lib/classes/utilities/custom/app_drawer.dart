import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myself_diary/classes/all_purchases.dart';
import 'package:myself_diary/classes/in_app_web_view.dart';
import 'package:myself_diary/classes/splash.dart';
import 'package:myself_diary/classes/utilities/APIs/resources.dart';
import 'package:myself_diary/classes/utilities/app_utilities/utils.dart';
import 'package:myself_diary/classes/utilities/custom/text.dart';
import 'package:myself_diary/classes/utilities/firebase/resources.dart';
// If you want to open links in-app, add url_launcher and uncomment below:
// import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _helpOpen = false; // controls expand/collapse

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: CustomText(
                FirebaseAuthUtils.name.toString(),
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              accountEmail: CustomText(
                FirebaseAuthUtils.email.toString(),
                color: Colors.grey,
              ),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.store),
              ),
              margin: EdgeInsets.zero,
            ),
            _drawerTile(
              icon: Icons.home_filled,
              title: "Home",
              onTap: () => _navigateFromDrawer(context, const SplashScreen()),
            ),
            _drawerTile(
              icon: Icons.list_alt,
              title: "Purchases",
              onTap: () => _navigateFromDrawer(
                context,
                GetAllPurchasesScreen(userId: FirebaseAuthUtils.uid.toString()),
              ),
            ),
            _drawerTile(
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () => _drawerAction(context, "Settings"),
            ),

            // -------- Help & Support (Expandable) --------
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Help & Support"),
              trailing: Icon(_helpOpen ? Icons.expand_less : Icons.expand_more),
              onTap: () => setState(() => _helpOpen = !_helpOpen),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _helpOpen
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Column(
                children: [
                  // Child tile 1
                  _drawerSubTile(
                    context: context,
                    title: "About Us",
                    icon: Icons.info_outline,
                    onTap: () {
                      _navigateFromDrawer(
                        context,
                        InAppWebViewScreen(
                          url: PolicyURL().aboutUs,
                          title: 'About Us',
                        ),
                      );
                    },
                  ),
                  // Child tile 2
                  _drawerSubTile(
                    context: context,
                    title: "Privacy",
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {
                      _navigateFromDrawer(
                        context,
                        InAppWebViewScreen(
                          url: PolicyURL().privacy,
                          title: 'Privacy Policy',
                        ),
                      );
                    },
                  ),
                  _drawerSubTile(
                    context: context,
                    title: "Terms",
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {
                      _navigateFromDrawer(
                        context,
                        InAppWebViewScreen(
                          url: PolicyURL().terms,
                          title: 'Terms & Conditions',
                        ),
                      );
                    },
                  ),
                ],
              ),
              secondChild: const SizedBox.shrink(),
            ),

            // ---------------------------------------------
            const Spacer(),
            const Divider(height: 0),
            _drawerTile(
              icon: Icons.logout,
              title: "Logout",
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Optional: open hosted pages in an in-app browser tab (Chrome Custom Tabs / SFSafariViewController)
  // Make sure to add url_launcher to pubspec and uncomment imports at the top.
  /*
  static Future<void> _openInAppTab(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  }
*/

  // push
  static void _navigateFromDrawer(BuildContext context, Widget page) {
    Navigator.pop(context); // close drawer
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static ListTile _drawerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // Indented child tile for the expandable section
  static Widget _drawerSubTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0), // indent
      child: ListTile(
        leading: Icon(icon, size: 20),
        title: Text(title),
        onTap: () {
          Navigator.pop(context); // close drawer before action
          onTap();
        },
      ),
    );
  }

  static void _drawerAction(BuildContext context, String where) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$where tapped")));
  }
}
