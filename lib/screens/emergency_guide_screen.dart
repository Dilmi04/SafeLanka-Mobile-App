import 'package:flutter/material.dart';
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
        heading: 'What to do during a flood',
        imageUrl: 'https://img.freepik.com/free-vector/flood-concept-illustration_114360-11116.jpg',
        steps: [
          'Move to higher ground immediately.',
          'Do not walk or drive through flooded areas.',
          'Turn off electricity at the main switch if safe.',
          'Keep emergency supplies in a safe place.',
          'Stay updated through official channels.',
        ],
      ),
      GuideItem(
        title: 'Landslide Safety',
        subtitle: 'How to stay safe during landslides',
        icon: Icons.terrain,
        iconColor: const Color(0xFF8D6E63),
        bgColor: const Color(0xFFEFEBE9),
        heading: 'How to stay safe during landslides',
        imageUrl: 'https://img.freepik.com/free-vector/disaster-concept-illustration_114360-10903.jpg',
        steps: [
          'Move to higher ground immediately.',
          'Do not stay in the path of a slide.',
          'Listen for unusual sounds like trees cracking.',
          'Keep emergency supplies in a safe place.',
          'Stay updated through official channels.',
        ],
      ),
      GuideItem(
        title: 'First Aid',
        subtitle: 'Basic first aid knowledge',
        icon: Icons.add_box,
        iconColor: const Color(0xFFE53935),
        bgColor: const Color(0xFFFFEBEE),
        heading: 'Basic first aid knowledge',
        imageUrl: 'https://img.freepik.com/free-vector/first-aid-kit-concept-illustration_114360-1284.jpg',
        steps: [
          'Check the scene for safety first.',
          'Call for emergency help immediately.',
          'Apply firm pressure to stop bleeding.',
          'Cool a burn with cold running water.',
          'Keep an injured person calm and still.',
        ],
      ),
      GuideItem(
        title: 'Fire Safety',
        subtitle: 'What to do during a fire',
        icon: Icons.local_fire_department,
        iconColor: const Color(0xFFF4511E),
        bgColor: const Color(0xFFFBE9E7),
        heading: 'What to do during a fire',
        imageUrl: 'https://img.freepik.com/free-vector/fire-safety-concept-illustration_114360-10878.jpg',
        steps: [
          'Get out immediately. Stay low to the floor.',
          'Feel doors before opening; if hot, use another exit.',
          'Use the stairs; do not use the elevator.',
          'If your clothes catch fire, stop, drop, and roll.',
          'Call emergency services once you are safe.',
        ],
      ),
      GuideItem(
        title: 'Earthquake Safety',
        subtitle: 'Safety tips during earthquakes',
        icon: Icons.gavel, // Note: Icon changed from gavel to earthquake-like icon in UI but kept for consistency
        iconColor: const Color(0xFF5E35B1),
        bgColor: const Color(0xFFEDE7F6),
        heading: 'Safety tips during earthquakes',
        imageUrl: 'https://img.freepik.com/free-vector/earthquake-disaster-concept-illustration_114360-11115.jpg',
        steps: [
          'Drop, Cover, and Hold On under sturdy furniture.',
          'Stay away from windows, glass, and outside walls.',
          'If in bed, stay there and protect your head with a pillow.',
          'Do not run outside until the shaking stops.',
          'If outdoors, move to a clear area away from buildings and trees.',
        ],
      ),
      GuideItem(
        title: 'Emergency Contacts',
        subtitle: 'Important hotline numbers',
        icon: Icons.phone,
        iconColor: const Color(0xFF43A047),
        bgColor: const Color(0xFFE8F5E9),
        heading: 'Important hotline numbers',
        imageUrl: 'https://img.freepik.com/free-vector/emergency-call-concept-illustration_114360-10904.jpg',
        steps: [
          'Police Emergency: 119',
          'Ambulance/Medical Emergency: 1990 (Suwa Seriya)',
          'Fire & Rescue Service: 110',
          'Disaster Management Centre: 117',
          'Tourist Police: 011 242 1052',
        ],
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 24),
            onPressed: () {},
          ),
        ],
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuideDetailsScreen(
                      title: item.title,
                      heading: item.heading,
                      imageUrl: item.imageUrl,
                      safetySteps: item.steps,
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
  final String heading;
  final String imageUrl;
  final List<String> steps;

  GuideItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.heading,
    required this.imageUrl,
    required this.steps,
  });
}
