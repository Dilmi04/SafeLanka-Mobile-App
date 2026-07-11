import 'package:flutter/material.dart';
import '../services/guide_service.dart';
import 'guide_details_screen.dart';

class EmergencyGuideScreen extends StatelessWidget {
  const EmergencyGuideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    final List<GuideItem> items = [
      GuideItem(
        title: 'Flood Safety',
        subtitle: 'What to do during a flood',
        icon: Icons.waves,
        iconColor: const Color(0xFF2B82C9),
        bgColor: const Color(0xFFE3F2FD),
        jsonFile: 'flood',
      ),
      GuideItem(
        title: 'Landslide Safety',
        subtitle: 'How to stay safe during landslides',
        icon: Icons.terrain,
        iconColor: const Color(0xFF8D6E63),
        bgColor: const Color(0xFFEFEBE9),
        jsonFile: 'landslide',
      ),
      GuideItem(
        title: 'First Aid',
        subtitle: 'Basic first aid knowledge',
        icon: Icons.add_box,
        iconColor: const Color(0xFFE53935),
        bgColor: const Color(0xFFFFEBEE),
        jsonFile: 'first_aid',
      ),
      GuideItem(
        title: 'Fire Safety',
        subtitle: 'What to do during a fire',
        icon: Icons.local_fire_department,
        iconColor: const Color(0xFFF4511E),
        bgColor: const Color(0xFFFBE9E7),
        jsonFile: 'fire',
      ),
      GuideItem(
        title: 'Earthquake Safety',
        subtitle: 'Safety tips during earthquakes',
        icon: Icons.vibration,
        iconColor: const Color(0xFF5E35B1),
        bgColor: const Color(0xFFEDE7F6),
        jsonFile: 'earthquake',
      ),
      GuideItem(
        title: 'Emergency Contacts',
        subtitle: 'Important hotline numbers',
        icon: Icons.phone,
        iconColor: const Color(0xFF43A047),
        bgColor: const Color(0xFFE8F5E9),
        jsonFile: 'contacts',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Emergency Guide',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: item.bgColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  item.icon,
                  color: item.iconColor,
                  size: 28,
                ),
              ),
              title: Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF212529),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  item.subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ),
              onTap: () async {
                final guide = await GuideService().loadGuide(item.jsonFile);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuideDetailsScreen(
                      title: guide.title,
                      heading: guide.heading,
                      imageUrl: guide.imageUrl,
                      safetySteps: guide.safetySteps,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


class GuideItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String jsonFile;

  GuideItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.jsonFile,
  });
}
