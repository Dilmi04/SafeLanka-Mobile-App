import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class MapService {
  static List<Map<String, dynamic>> safeLocations = [
    {
      "name": "Nearest Hospital",
      "type": "Hospital",
      "lat": 6.9271,
      "lng": 79.8612
    },
    {
      "name": "Police Station",
      "type": "Police",
      "lat": 6.9147,
      "lng": 79.9737
    }
  ];

  static Future<void> openMapDirections(double lat, double lng) async {
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng";
    final Uri url = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  static void sharePlaceDetails(String name, String address, String phone, double lat, double lng) {
    final String mapLink = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    final String text = "🚨 SafeLanka Emergency Location 🚨\n\n"
        "📍 Name: $name\n"
        "🏠 Address: $address\n"
        "📞 Contact: $phone\n\n"
        "🗺️ View on Map:\n$mapLink\n\n"
        "Stay safe!";
    Share.share(text);
  }
}
