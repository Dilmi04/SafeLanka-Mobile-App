import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  static const String _apiKey = 'AIzaSyAp2Rsf3n7hE8YZ6HFGsU8_xPQkjZQNcxc';
  late GenerativeModel _model;

  AiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  Future<String> getResponse(String prompt) async {
    try {
      final content = [Content.text("You are an emergency assistant for 'SafeLanka' app. User asks: " + prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      }
    } catch (e) {
      print("Gemini API Error: $e");
    }

    return _getFallbackResponse(prompt.toLowerCase());
  }

  String _getFallbackResponse(String input) {
    if (input.contains("flood")) {
      return "🚨 Flood Safety Tips:\n\n"
          "1. Move to the highest possible floor or higher ground immediately.\n"
          "2. Turn off all electricity and gas valves to prevent accidents.\n"
          "3. Do not walk, swim, or drive through flood waters. Just 6 inches of moving water can knock you down.\n"
          "4. Drink only bottled or boiled water.\n"
          "📞 Call 117 for Disaster Management assistance.";
    }

    if (input.contains("fire")) {
      return "🔥 Fire Emergency Guidelines:\n\n"
          "1. Evacuate the building immediately using the nearest safe exit.\n"
          "2. If there is smoke, stay low to the ground and crawl.\n"
          "3. DO NOT use elevators under any circumstances.\n"
          "4. If your clothes catch fire: Stop, Drop, and Roll.\n"
          "📞 Call 110 for the Fire Department immediately.";
    }

    if (input.contains("landslide")) {
      return "⛰️ Landslide Warning & Safety:\n\n"
          "1. Look for warning signs like cracks in the ground, tilted trees, or muddy water flow.\n"
          "2. If you are inside, stay away from windows and move to the center of the building.\n"
          "3. If you are outside, run to the nearest high ground away from the path of debris.\n"
          "4. Listen to local news for evacuation orders.\n"
          "📞 Contact 117 for emergency rescue.";
    }

    if (input.contains("first aid")) {
      return "🩹 Basic First Aid Instructions:\n\n"
          "• Bleeding: Apply firm pressure to the wound with a clean cloth.\n"
          "• Burns: Hold the area under cool running water for at least 10 minutes. Do not use ice.\n"
          "• Choking: Perform the Heimlich maneuver if trained, or call for help immediately.\n"
          "• Unconscious: Check for breathing. If not breathing, start CPR if you know how.\n"
          "📞 Call 1990 for the Suwa Seriya Ambulance service.";
    }

    if (input.contains("contact") || input.contains("number")) {
      return "☎️ Emergency Contact Numbers in Sri Lanka:\n\n"
          "• Police Emergency: 119\n"
          "• Ambulance (Suwa Seriya): 1990\n"
          "• Fire & Rescue: 110\n"
          "• Disaster Management: 117\n"
          "• Child & Women Helpline: 1929\n"
          "Stay safe, I am here to help!";
    }

    if (input.contains("hello") || input.contains("hi") || input.contains("who are you")) {
      return "Hello! I am your SafeLanka AI Assistant. 🛡️\n\n"
          "I can provide life-saving information during floods, fires, landslides, and medical emergencies. How can I help you stay safe today?";
    }

    return "I am your SafeLanka assistant. I can give you safety tips for floods, fires, landslides, or provide emergency contact numbers. What do you need help with?";
  }
}
