import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myself_diary/classes/all_purchases.dart';
import 'package:myself_diary/classes/splash.dart';
import 'package:myself_diary/classes/utilities/custom/text.dart';
import 'package:myself_diary/classes/utilities/firebase/resources.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
              currentAccountPicture: CircleAvatar(child: Icon(Icons.store)),
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
            /*_drawerTile(
              icon: Icons.receipt_long,
              title: "Orders",
              onTap: () => _drawerAction(context, "Orders"),
            ),*/
            _drawerTile(
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () => _drawerAction(context, "Settings"),
            ),
            const Spacer(),
            const Divider(height: 0),
            _drawerTile(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () => _drawerAction(context, "Help & Support"),
            ),
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

  // push
  static void _navigateFromDrawer(BuildContext context, Widget page) {
    Navigator.pop(context); // drawer close
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

  static void _drawerAction(BuildContext context, String where) {
    Navigator.pop(context); // close drawer
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("$where tapped")));
  }
}
