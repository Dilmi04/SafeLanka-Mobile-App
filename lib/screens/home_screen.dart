import 'package:flutter/material.dart';
import 'package:safelanka/services/auth_service.dart';
import 'package:safelanka/services/map_service.dart';
import 'package:safelanka/utils/constants.dart';
import 'navigation_drawer.dart';
import 'map_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature screen coming soon')),
    );
  }

  void _showHotlineSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                const Text("Emergency Hotlines", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const _HotlineTile(icon: Icons.local_police, label: "Police Emergency", number: "119", color: Colors.blue),
                const _HotlineTile(icon: Icons.medical_services, label: "Ambulance (Suwa Seriya)", number: "1990", color: Colors.red),
                const _HotlineTile(icon: Icons.local_fire_department, label: "Fire & Rescue", number: "110", color: Colors.orange),
                const _HotlineTile(icon: Icons.gpp_maybe, label: "Disaster Management", number: "117", color: Colors.green),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final userName = user?.displayName ?? "Guest";

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
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, $userName 👋",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Stay safe and alert!",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (user == null)
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text("Login", style: TextStyle(fontSize: 13)),
                  ),
              ],
            ),
            if (user == null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        "Sign up to enable SOS alerts and save emergency contacts.",
                        style: TextStyle(fontSize: 12, color: AppColors.textDark),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

            // ---- SOS banner ----
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/sos'),
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
                  onTap: () => Navigator.pushNamed(context, '/emergency-guide'),
                ),
                _FeatureCard(
                  icon: Icons.person_rounded,
                  iconColor: AppColors.missingPurple,
                  title: "Missing Person",
                  subtitle: "Report & search missing persons",
                  onTap: () => Navigator.pushNamed(context, '/missing-list'),
                ),
                _FeatureCard(
                  icon: Icons.mic_rounded,
                  iconColor: AppColors.primary,
                  title: "AI Assistant",
                  subtitle: "Voice assistant for help",
                  onTap: () => Navigator.pushNamed(context, '/ai-assistant'),
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
                    onTap: () => _showHotlineSheet(context),
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
                onTap: () => Navigator.pushNamed(context, '/sos'),
              ),
              _NavIcon(
                icon: Icons.menu_book_outlined,
                label: "Guide",
                onTap: () => Navigator.pushNamed(context, '/emergency-guide'),
              ),
              _NavIcon(
                icon: Icons.person_outline,
                label: "Profile",
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HotlineTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String number;
  final Color color;

  const _HotlineTile({required this.icon, required this.label, required this.number, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(number, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.call, color: Colors.green),
        onTap: () => MapService.makePhoneCall(number),
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

  void _showHotlineSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                const Text("Emergency Hotlines", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const _HotlineTile(icon: Icons.local_police, label: "Police Emergency", number: "119", color: Colors.blue),
                const _HotlineTile(icon: Icons.medical_services, label: "Ambulance (Suwa Seriya)", number: "1990", color: Colors.red),
                const _HotlineTile(icon: Icons.local_fire_department, label: "Fire & Rescue", number: "110", color: Colors.orange),
                const _HotlineTile(icon: Icons.gpp_maybe, label: "Disaster Management", number: "117", color: Colors.green),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  void _showHotlineSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                ),
                const Text("Emergency Hotlines", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                const _HotlineTile(icon: Icons.local_police, label: "Police Emergency", number: "119", color: Colors.blue),
                const _HotlineTile(icon: Icons.medical_services, label: "Ambulance (Suwa Seriya)", number: "1990", color: Colors.red),
                const _HotlineTile(icon: Icons.local_fire_department, label: "Fire & Rescue", number: "110", color: Colors.orange),
                const _HotlineTile(icon: Icons.gpp_maybe, label: "Disaster Management", number: "117", color: Colors.green),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
