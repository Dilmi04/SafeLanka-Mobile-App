import 'package:flutter/material.dart';

class AiVoiceAssistantScreen extends StatelessWidget {
  const AiVoiceAssistantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dynamic list containing the prompt suggestions
    final List<String> suggestions = [
      'What should I do in a flood?',
      'How to provide first aid?',
      'Show nearest hospital',
      'Emergency numbers',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFBFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'AI Assistant',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 1. Center Glowing Voice Assistant Ring Visualizer
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFA78BFA), // Pastel purple top
                        Color(0xFF38BDF8), // Light blue bottom
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      // Outer soft visualizer ring effect
                      BoxShadow(
                        color: const Color(0xFF38BDF8).withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 15,
                      ),
                      // Inner tighter glowing halo
                      BoxShadow(
                        color: const Color(0xFFA78BFA).withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mic_none_outlined,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // 2. Titles & Subtitles
              const Text(
                'How can I help you?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can ask me things like:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              // 3. Question Suggestion Chips
              ...suggestions.map((text) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26.0), // Rounded pill style
                          ),
                        ),
                        child: Text(
                          text,
                          style: const TextStyle(
                            color: Color(0xFF334155),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )),

              const Spacer(flex: 3),

              // 4. Bottom Interaction Floating Bar Action Area
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bottom Left Icon Option
                  IconButton(
                    icon: Icon(Icons.help_outline, color: Colors.grey[400], size: 26),
                    onPressed: () {},
                  ),
                  
                  // Central Active Capture Button
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF3B82F6), // Strong material action blue
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  
                  // Bottom Right Icon Option
                  IconButton(
                    icon: Icon(Icons.chat_bubble_outline, color: Colors.grey[400], size: 24),
                   onPressed: () {
  Navigator.pop(context);
},
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}