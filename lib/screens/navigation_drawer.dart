import 'package:flutter/material.dart';
import 'package:safelanka/services/auth_service.dart';
import 'package:safelanka/utils/constants.dart';
import 'package:safelanka/screens/login_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    final userName = user?.displayName ?? "Guest";

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ---- Header ----
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: AppColors.primaryDark,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.shield,
                      color: AppColors.primaryDark, size: 26),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: "Safe",
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: "Lanka",
                              style:
                              TextStyle(color: AppColors.guideOrange)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user != null
                          ? "Welcome, $userName"
                          : "Stay safe, Stay prepared",
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          _DrawerTile(
            icon: Icons.home_outlined,
            label: "Home",
            selected: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
          ),
          _DrawerTile(
            icon: Icons.location_on_outlined,
            label: "Safe Locations",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MapScreen()));
            },
          ),
          _DrawerTile(
            icon: Icons.menu_book_outlined,
            label: "Emergency Guide",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/emergency-guide');
            },
          ),
          _DrawerTile(
            icon: Icons.person_search_outlined,
            label: "Missing Persons",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/missing-list');
            },
          ),
          _DrawerTile(
            icon: Icons.mic_none,
            label: "AI Assistant",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ai-assistant');
            },
          ),
          _DrawerTile(
            icon: Icons.contact_phone_outlined,
            label: "Emergency Contacts",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/contacts');
            },
          ),
          _DrawerTile(
            icon: Icons.person_outline,
            label: "Profile",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          _DrawerTile(
            icon: Icons.settings_outlined,
            label: "Settings",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          _DrawerTile(
            icon: Icons.info_outline,
            label: "About Us",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 24),
          ),

          // ── Logout / Login button ──
          if (user != null)
            _DrawerTile(
              icon: Icons.logout,
              label: "Logout",
              color: AppColors.sosRed,
              onTap: () async {
                // Close drawer first
                Navigator.pop(context);

                // Show loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  await authService.signOut().timeout(
                    const Duration(seconds: 5),
                    onTimeout: () {
                      debugPrint('Sign out timed out, forcing navigation');
                    },
                  );
                } catch (e) {
                  debugPrint('Logout error: $e');
                }

                // Close loading dialog and go to login
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context, rootNavigator: true)
                      .pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                        (route) => false, // clear all routes
                  );
                }
              },
            )
          else
            _DrawerTile(
              icon: Icons.login,
              label: "Login / Sign Up",
              color: AppColors.primary,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor =
        color ?? (selected ? AppColors.primaryDark : Colors.black87);
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: tileColor, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: tileColor,
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}