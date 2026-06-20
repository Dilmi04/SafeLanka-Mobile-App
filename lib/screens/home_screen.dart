import 'package:flutter/material.dart';
import 'navigation_drawer.dart';
import 'map_screen.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primary = Color(0xFF1565C0);
  static const Color sosRed = Color(0xFFF44336);
  static const Color guideOrange = Color(0xFFFF9800);
  static const Color safeGreen = Color(0xFF4CAF50);
  static const Color missingPurple = Color(0xFF7E57C2);
  static const Color navGrey = Color(0xFF9AA3AF);
  static const Color background = Color(0xFFF5F7FA);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature screen coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: "Safe", style: TextStyle(color: AppColors.primaryDark)),
              TextSpan(text: "Lanka", style: TextStyle(color: AppColors.guideOrange)),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hello, Dilmi 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Stay safe and alert!",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // ---- SOS banner ----
            GestureDetector(
              onTap: () => _showComingSoon(context, "SOS Alert"),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.sosRed,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SOS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Tap to send emergency alert",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_active,
                          color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.95,
              children: [
                _FeatureCard(
                  icon: Icons.home_rounded,
                  iconColor: AppColors.safeGreen,
                  title: "Safe Locations",
                  subtitle: "Find nearby safe places",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  MapScreen()),
                  ),
                ),
                _FeatureCard(
                  icon: Icons.menu_book_rounded,
                  iconColor: AppColors.guideOrange,
                  title: "Emergency Guide",
                  subtitle: "Offline safety information",
                  onTap: () => _showComingSoon(context, "Emergency Guide"),
                ),
                _FeatureCard(
                  icon: Icons.person_rounded,
                  iconColor: AppColors.missingPurple,
                  title: "Missing Person",
                  subtitle: "Report & search missing persons",
                  onTap: () => _showComingSoon(context, "Missing Person"),
                ),
                _FeatureCard(
                  icon: Icons.mic_rounded,
                  iconColor: AppColors.primary,
                  title: "AI Assistant",
                  subtitle: "Voice assistant for help",
                  onTap: () => _showComingSoon(context, "AI Assistant"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ---- Emergency hotline card ----
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Emergency Hotline",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 2),
                        Text("Quick access to important hotline numbers",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showComingSoon(context, "Emergency Hotline"),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: AppColors.safeGreen, shape: BoxShape.circle),
                      child: const Icon(Icons.call, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24), 
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(icon: Icons.home_outlined, label: "Home", selected: true, onTap: () {}),
              _NavIcon(
                icon: Icons.map_outlined,
                label: "Map",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapScreen()),
                ),
              ),
              _NavIcon(
                icon: Icons.gps_fixed,
                label: "SOS",
                onTap: () => _showComingSoon(context, "SOS Alert"),
              ),
              _NavIcon(
                icon: Icons.menu_book_outlined,
                label: "Guide",
                onTap: () => _showComingSoon(context, "Guide"),
              ),
              _NavIcon(
                icon: Icons.person_outline,
                label: "Profile",
                onTap: () => _showComingSoon(context, "Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryDark : AppColors.navGrey;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
