import 'package:flutter/material.dart';
import 'place_details_screen.dart';

class AppColors {
  static const Color primary = Color(0xFF1565C0);
  static const Color sosRed = Color(0xFFF44336);
  static const Color safeGreen = Color(0xFF4CAF50);
  static const Color background = Color(0xFFF5F7FA);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF757575);
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          "Safe Locations",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search hospitals, police, shelters...",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Map Area Layout
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFE8F0FE), 
                image: const DecorationImage(
                  image: AssetImage('assets/map_placeholder.png'),
                  fit: BoxFit.cover,
                  opacity: 0.1,
                ),
              ),
              child: Stack(
                children: [
                  // Current location indicator
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Hospital Pin
                  Positioned(
                    top: 60,
                    left: 60,
                    child: _buildMapPin(Icons.location_on, AppColors.sosRed),
                  ),

                  // Police Pin
                  Positioned(
                    top: 80,
                    right: 70,
                    child: _buildMapPin(Icons.location_on, AppColors.primary),
                  ),

                  // Shelter Pin
                  Positioned(
                    bottom: 70,
                    left: 90,
                    child: _buildMapPin(Icons.location_on, AppColors.safeGreen),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Nearby Places Label
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Nearby Places",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ListView containing nearby places
          SizedBox(
            height: 260,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              children: [
                placeCard(
                  context,
                  Icons.local_hospital_rounded,
                  "City Hospital",
                  "Hospital",
                  "0.8 km away",
                  AppColors.sosRed,
                ),
                placeCard(
                  context,
                  Icons.local_police_rounded,
                  "Central Police Station",
                  "Police",
                  "1.2 km away",
                  AppColors.primary,
                ),
                placeCard(
                  context,
                  Icons.home_rounded,
                  "Community Shelter",
                  "Shelter",
                  "1.5 km away",
                  AppColors.safeGreen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMapPin(IconData icon, Color color) {
    return Icon(
      icon,
      size: 36,
      color: color,
    );
  }

  Widget placeCard(
      BuildContext context,
      IconData icon,
      String name,
      String type,
      String distance,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlaceDetailsScreen(
                placeName: name,
                placeType: type,
                distance: distance,
              ),
            ),
          );
        },
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            distance,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 13,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
