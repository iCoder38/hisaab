import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Obonstore"),
              accountEmail: Text("hello@obonstore.com"),
              currentAccountPicture: CircleAvatar(child: Icon(Icons.store)),
              margin: EdgeInsets.zero,
            ),
            _drawerTile(
              icon: Icons.home_filled,
              title: "Home",
              onTap: () => _drawerAction(context, "Home"),
            ),
            _drawerTile(
              icon: Icons.account_balance_wallet_outlined,
              title: "Wallet",
              onTap: () => _drawerAction(context, "Wallet"),
            ),
            _drawerTile(
              icon: Icons.receipt_long,
              title: "Orders",
              onTap: () => _drawerAction(context, "Orders"),
            ),
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
              onTap: () => _drawerAction(context, "Logout"),
            ),
          ],
        ),
      ),
    );
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
