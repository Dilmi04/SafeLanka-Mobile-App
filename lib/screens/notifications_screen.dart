import 'package:flutter/material.dart';
import 'package:safelanka/utils/constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> alerts = [
      {
        "title": "Flood Warning",
        "desc": "Heavy rainfall expected in Galle and Matara districts. Stay alert near river banks.",
        "time": "2 hours ago",
        "type": "Danger"
      },
      {
        "title": "Missing Person Found",
        "desc": "Kavindu Perera who was reported missing has been safely located.",
        "time": "5 hours ago",
        "type": "Info"
      },
      {
        "title": "Landslide Alert",
        "desc": "Level 2 landslide warning issued for Ratnapura and Kegalle areas.",
        "time": "1 day ago",
        "type": "Warning"
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Safety Alerts", style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: alerts.isEmpty
          ? const Center(child: Text("No new notifications"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: _getTypeColor(alert['type']!).withOpacity(0.1),
                      child: Icon(_getTypeIcon(alert['type']!), color: _getTypeColor(alert['type']!)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(alert['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(alert['time']!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(alert['desc']!, style: const TextStyle(fontSize: 13, height: 1.4)),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getTypeColor(String type) {
    if (type == "Danger") return Colors.red;
    if (type == "Warning") return Colors.orange;
    return Colors.blue;
  }

  IconData _getTypeIcon(String type) {
    if (type == "Danger") return Icons.gpp_maybe;
    if (type == "Warning") return Icons.warning_amber_rounded;
    return Icons.info_outline;
  }
}
