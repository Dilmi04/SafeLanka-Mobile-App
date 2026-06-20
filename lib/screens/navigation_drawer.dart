import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';


class AppColors {
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color guideOrange = Color(0xFFFF9800);
  static const Color sosRed = Color(0xFFF44336);
}

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature screen coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.shield, color: AppColors.primaryDark, size: 26),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: "Safe", style: TextStyle(color: Colors.white)),
                          TextSpan(text: "Lanka", style: TextStyle(color: AppColors.guideOrange)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Stay safe, Stay prepared",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
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
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            },
          ),
          _DrawerTile(
            icon: Icons.location_on_outlined,
            label: "Safe Locations",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MapScreen()));
            },
          ),
          _DrawerTile(
            icon: Icons.menu_book_outlined,
            label: "Emergency Guide",
            onTap: () => _showComingSoon(context, "Emergency Guide"),
          ),
          _DrawerTile(
            icon: Icons.person_search_outlined,
            label: "Missing Persons",
            onTap: () => _showComingSoon(context, "Missing Persons"),
          ),
          _DrawerTile(
            icon: Icons.mic_none,
            label: "AI Assistant",
            onTap: () => _showComingSoon(context, "AI Assistant"),
          ),
          _DrawerTile(
            icon: Icons.contact_phone_outlined,
            label: "Emergency Contacts",
            onTap: () => _showComingSoon(context, "Emergency Contacts"),
          ),
          _DrawerTile(
            icon: Icons.person_outline,
            label: "Profile",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          _DrawerTile(
            icon: Icons.settings_outlined,
            label: "Settings",
            onTap: () => _showComingSoon(context, "Settings"),
          ),
          _DrawerTile(
            icon: Icons.info_outline,
            label: "About Us",
            onTap: () => _showComingSoon(context, "About Us"),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 24),
          ),

          _DrawerTile(
            icon: Icons.logout,
            label: "Logout",
            color: AppColors.sosRed,
            onTap: () => Navigator.pop(context),
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
    final tileColor = color ?? (selected ? AppColors.primaryDark : Colors.black87);
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
