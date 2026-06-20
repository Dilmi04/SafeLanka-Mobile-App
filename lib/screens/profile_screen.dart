import 'package:flutter/material.dart';

// Colors are defined right here at the top of the file.
// No separate file needed - just copy this whole file as-is.
class AppColors {
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color sosRed = Color(0xFFF44336);
  static const Color background = Color(0xFFF5F7FA);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.black87, size: 20),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ---- Avatar + info ----
          Row(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: Color(0xFFE3ECF8),
                child: Icon(Icons.person, size: 36, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dilmi Perera",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("070 123 4567", style: TextStyle(color: Colors.black54, fontSize: 13)),
                    Text("dilmi@example.com", style: TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          _ProfileMenuTile(icon: Icons.call_outlined, label: "My Emergency Contacts", onTap: () {}),
          _ProfileMenuTile(icon: Icons.notifications_none, label: "Notification Settings", onTap: () {}),
          _ProfileMenuTile(icon: Icons.lock_outline, label: "Privacy & Security", onTap: () {}),
          _ProfileMenuTile(icon: Icons.help_outline, label: "Help & Support", onTap: () {}),
          _ProfileMenuTile(icon: Icons.info_outline, label: "About SafeLanka", onTap: () {}),

          const SizedBox(height: 20),

          // ---- Logout button ----
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: AppColors.sosRed, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Logout",
                      style: TextStyle(color: AppColors.sosRed, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileMenuTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.black87, size: 22),
        title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}