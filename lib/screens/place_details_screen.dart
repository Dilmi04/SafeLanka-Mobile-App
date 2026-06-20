import 'package:flutter/material.dart';

// Colors are defined right here at the top of the file.
// No separate file needed - just copy this whole file as-is.
class AppColors {
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primary = Color(0xFF1565C0);
  static const Color sosRed = Color(0xFFF44336);
  static const Color guideOrange = Color(0xFFFF9800);
  static const Color safeGreen = Color(0xFF4CAF50);
  static const Color background = Color(0xFFF5F7FA);
}

class PlaceDetailsScreen extends StatelessWidget {
  final String placeName;
  final String placeType;
  final String distance;
  final String address;
  final String openHours;
  final String aboutText;
  final List<String> facilities;

  const PlaceDetailsScreen({
    super.key,
    required this.placeName,
    required this.placeType,
    required this.distance,
    this.address = "No. 123, Main Street, Colombo 08",
    this.openHours = "Open 24 Hours",
    this.aboutText =
    "This place provides 24/7 emergency services and support for SafeLanka users.",
    this.facilities = const ["Emergency", "Pharmacy", "Ambulance"],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Hero image with back button overlay ----
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFBBD3F0), Color(0xFFE3ECF8)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      placeType.toLowerCase() == "hospital"
                          ? Icons.local_hospital
                          : placeType.toLowerCase() == "police"
                          ? Icons.local_police
                          : Icons.home_work,
                      size: 90,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 16,
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, size: 20, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ---- Details ----
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placeName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    placeType,
                    style: const TextStyle(
                      color: AppColors.sosRed,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // open hours pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.safeGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_filled, size: 14, color: AppColors.safeGreen),
                        const SizedBox(width: 6),
                        Text(
                          openHours,
                          style: const TextStyle(
                            color: AppColors.safeGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(address, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.near_me_outlined, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text("$distance away", style: const TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ---- Action buttons ----
                  Row(
                    children: [
                      Expanded(child: _PillButton(icon: Icons.call_outlined, label: "Call", onTap: () {})),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PillButton(
                          icon: Icons.navigation_outlined,
                          label: "Directions",
                          filled: true,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _PillButton(icon: Icons.share_outlined, label: "Share", onTap: () {})),
                    ],
                  ),

                  const SizedBox(height: 26),

                  const Text("About", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    aboutText,
                    style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.5),
                  ),

                  const SizedBox(height: 22),

                  const Text("Facilities", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: facilities.map((f) => _FacilityTag(label: f)).toList(),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : const Color(0xFFF0F2F5),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: filled ? Colors.white : Colors.black87),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: filled ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FacilityTag extends StatelessWidget {
  final String label;
  const _FacilityTag({required this.label});

  @override
  Widget build(BuildContext context) {
    // Alternate tint so tags don't all look identical, like the design.
    final isOrange = label.toLowerCase() == "pharmacy";
    final color = isOrange ? AppColors.guideOrange : AppColors.sosRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}