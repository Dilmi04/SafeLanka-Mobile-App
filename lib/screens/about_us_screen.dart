import 'package:flutter/material.dart';
import 'package:safelanka/utils/constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "About Us",
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_rounded, size: 80, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: "Safe", style: TextStyle(color: AppColors.primary)),
                        TextSpan(text: "Lanka", style: TextStyle(color: AppColors.guideOrange)),
                      ],
                    ),
                  ),
                  const Text("Version 1.0.0", style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Our Mission",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            const Text(
              "SafeLanka is dedicated to enhancing the personal safety of every citizen in Sri Lanka. Our app provides real-time emergency alerts, location-based safety information, and advanced AI assistance to ensure you are never alone in a crisis.",
              style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
            ),
            const SizedBox(height: 30),
            const Text(
              "Key Features",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(Icons.sos_rounded, "Instant SOS Alerts"),
            _buildFeatureItem(Icons.map_rounded, "Verified Safe Locations"),
            _buildFeatureItem(Icons.psychology_rounded, "AI Safety Assistant"),
            _buildFeatureItem(Icons.groups_rounded, "Community Support"),
            
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Developed with ❤️ by Team SafeLanka",
                style: TextStyle(color: AppColors.textGrey, fontSize: 13),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "© 2024 SafeLanka. All rights reserved.",
                style: TextStyle(color: AppColors.textGrey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }
}
