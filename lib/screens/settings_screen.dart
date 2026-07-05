import 'package:flutter/material.dart';
import 'package:safelanka/utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader("Account"),
          _buildSettingsTile(Icons.person_outline, "Edit Profile", "Change your name, email, etc."),
          _buildSettingsTile(Icons.lock_outline, "Change Password", "Update your security credentials"),
          
          const SizedBox(height: 16),
          _buildSectionHeader("Notifications"),
          _buildSettingsTile(Icons.notifications_outlined, "Alert Notifications", "Manage SOS and safety alerts", isSwitch: true, switchValue: true),
          _buildSettingsTile(Icons.volume_up_outlined, "Sound & Vibration", "Configure alert sounds"),

          const SizedBox(height: 16),
          _buildSectionHeader("Privacy & Security"),
          _buildSettingsTile(Icons.location_on_outlined, "Location Permissions", "Manage app access to GPS"),
          _buildSettingsTile(Icons.security_outlined, "Emergency Settings", "Configure SOS trigger options"),

          const SizedBox(height: 16),
          _buildSectionHeader("General"),
          _buildSettingsTile(Icons.language_outlined, "Language", "English (US)"),
          _buildSettingsTile(Icons.dark_mode_outlined, "Theme", "Light Mode", isSwitch: true, switchValue: false),
          
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {},
            child: const Text("Deactivate Account", style: TextStyle(color: AppColors.sosRed)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, {bool isSwitch = false, bool switchValue = false}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textDark),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
        trailing: isSwitch 
          ? Switch(value: switchValue, onChanged: (v) {}, activeColor: AppColors.primary)
          : const Icon(Icons.chevron_right, size: 20),
        onTap: () {},
      ),
    );
  }
}
