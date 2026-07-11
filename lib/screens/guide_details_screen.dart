import 'package:flutter/material.dart';

class GuideDetailsScreen extends StatelessWidget {
  final String title;
  final String heading;
  final String imageUrl;
  final List<String> safetySteps;

  const GuideDetailsScreen({
    Key? key,
    required this.title,
    required this.heading,
    required this.imageUrl,
    required this.safetySteps,
  }) : super(key: key);

  IconData _getFallbackIcon(String title) {
    if (title.contains('Flood')) return Icons.waves;
    if (title.contains('Landslide')) return Icons.terrain;
    if (title.contains('First Aid')) return Icons.add_box;
    if (title.contains('Fire')) return Icons.local_fire_department;
    if (title.contains('Earthquake')) return Icons.vibration;
    return Icons.info_outline;
  }

  Widget _buildErrorWidget() {
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Center(
        child: Icon(_getFallbackIcon(title), size: 80, color: Colors.blueGrey[100]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      },
                      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
                    )
                  : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
                    ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              heading,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 24),
            ...safetySteps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 14.0),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          step,
                          style: const TextStyle(fontSize: 16, color: Color(0xFF475569), height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
