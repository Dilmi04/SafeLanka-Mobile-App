import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:safelanka/screens/splash_screen.dart';
import 'package:safelanka/screens/login_screen.dart';
import 'package:safelanka/screens/signup_screen.dart';
import 'package:safelanka/screens/sos_screen.dart';
import 'package:safelanka/screens/emergency_contacts_screen.dart';
import 'package:safelanka/screens/home_screen.dart';
import 'package:safelanka/screens/map_screen.dart';
import 'package:safelanka/screens/place_details_screen.dart';
import 'package:safelanka/screens/emergency_guide_screen.dart';
import 'package:safelanka/screens/guide_details_screen.dart';
import 'package:safelanka/screens/missing_list_screen.dart';
import 'package:safelanka/screens/missing_report_screen.dart';
import 'package:safelanka/screens/report_details_screen.dart';
import 'package:safelanka/screens/ai_assistant_screen.dart';
import 'package:safelanka/screens/profile_screen.dart';
import 'package:safelanka/screens/settings_screen.dart';
import 'package:safelanka/screens/about_us_screen.dart';
import 'package:safelanka/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Display errors on screen instead of a blank page
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: Colors.red,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(
            'App Error:\n\n${details.exception}\n\n${details.stack}',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  };

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAs-Placeholder-Key",
          appId: "1:1234567890:web:placeholder",
          messagingSenderId: "1234567890",
          projectId: "safelanka-placeholder",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }

  runApp(const SafeLankaApp());
}

class SafeLankaApp extends StatelessWidget {
  const SafeLankaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeLanka',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/login':     (_) => const LoginScreen(),
        '/signup':    (_) => const SignupScreen(),
        '/home':      (_) => const HomeScreen(),
        '/sos':       (_) => const SosScreen(),
        '/contacts':  (_) => const EmergencyContactsScreen(),
        '/map':       (_) => const MapScreen(),
        '/profile':   (_) => const ProfileScreen(),
        '/emergency-guide': (_) => const EmergencyGuideScreen(),
        '/ai-assistant': (_) => const AiVoiceAssistantScreen(),
        '/missing-list': (_) => const MissingPersonsListScreen(),
        '/missing-report': (_) => const ReportMissingPersonScreen(),
        '/missing-details': (_) => const MissingPersonDetailsScreen(),
        '/settings':  (_) => const SettingsScreen(),
        '/about':     (_) => const AboutUsScreen(),
        '/place':     (_) => const PlaceDetailsScreen(
          placeName: "City Hospital",
          placeType: "Hospital",
          distance: "0.8 km",
        ),
      },
    );
  }
}
