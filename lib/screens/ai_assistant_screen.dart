import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/ai_service.dart';

class AiVoiceAssistantScreen extends StatefulWidget {
  const AiVoiceAssistantScreen({Key? key}) : super(key: key);

  @override
  State<AiVoiceAssistantScreen> createState() => _AiVoiceAssistantScreenState();
}

class _AiVoiceAssistantScreenState extends State<AiVoiceAssistantScreen> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  final AiService _aiService = AiService();

  bool _isListening = false;
  String _text = 'Tap the microphone to ask a question...';
  String _aiResponse = "";
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _setupTts();
  }

  void _setupTts() {
    _flutterTts.setStartHandler(() => setState(() => _isSpeaking = true));
    _flutterTts.setCompletionHandler(() => setState(() => _isSpeaking = false));
    _flutterTts.setErrorHandler((msg) => setState(() => _isSpeaking = false));
  }

  void _speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak(text);
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() {
          _isListening = true;
          _text = "Listening..."; // පරණ එක මකනවා
          _aiResponse = ""; // පරණ එක මකනවා
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();

      // Process with AI Service
      if (_text.isNotEmpty && _text != 'Listening...') {
        setState(() => _aiResponse = "Thinking...");
        String response = await _aiService.getResponse(_text);
        setState(() => _aiResponse = response);
        _speak(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFBFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () {
            _flutterTts.stop();
            Navigator.pop(context);
          },
        ),
        title: const Text('SafeLanka AI Assistant', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Center(
                child: AvatarGlow(
                  animate: _isListening || _isSpeaking,
                  glowColor: _isSpeaking ? Colors.green : const Color(0xFF6366F1),
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  child: GestureDetector(
                    onTap: _listen,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _isSpeaking
                            ? [Colors.tealAccent, Colors.teal]
                            : [const Color(0xFF818CF8), const Color(0xFF6366F1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : (_isSpeaking ? Icons.volume_up : Icons.mic_none_rounded),
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.indigo.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _aiResponse.isEmpty ? "I am your emergency assistant. Ask me anything about safety guidelines or first aid." : _aiResponse,
                      style: const TextStyle(fontSize: 17, color: Color(0xFF1E293B), height: 1.6, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isListening ? "Listening..." : (_isSpeaking ? "Assistant is speaking..." : "Tap to talk"),
                style: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
