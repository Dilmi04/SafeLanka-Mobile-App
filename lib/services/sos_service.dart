import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:safelanka/models/emergency_contact_model.dart';

class SosService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  // ─── Get current GPS position ─────────────────────────────────────────────
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permission permanently denied. Enable it in settings.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  // ─── Send SOS alert ───────────────────────────────────────────────────────
  Future<void> sendSosAlert() async {
    if (_uid.isEmpty) throw Exception('User not logged in.');

    // 1. Get location
    final pos = await getCurrentPosition();
    final lat = pos.latitude;
    final lng = pos.longitude;
    final mapsLink = 'https://maps.google.com/?q=$lat,$lng';

    // 2. Get emergency contacts
    final contacts = await getEmergencyContacts();
    if (contacts.isEmpty) {
      throw Exception(
          'No emergency contacts found. Please add contacts first.');
    }

    // 3. Save SOS alert to Firestore
    await _db.collection('sos_alerts').add({
      'uid': _uid,
      'latitude': lat,
      'longitude': lng,
      'mapsLink': mapsLink,
      'timestamp': FieldValue.serverTimestamp(),
      'contacts': contacts.map((c) => c.toMap()).toList(),
      'status': 'sent',
    });

    // 4. Send SMS to each contact via url_launcher (sms: scheme)
    final msg = Uri.encodeComponent(
      '🆘 SOS ALERT from SafeLanka!\n'
          'I need help. My location:\n$mapsLink\n'
          'Please contact me immediately or send help.',
    );

    for (final contact in contacts) {
      final smsUri = Uri.parse('sms:${contact.phone}?body=$msg');
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }
    }
  }

  // ─── Emergency Contacts CRUD ──────────────────────────────────────────────

  /// Get all emergency contacts for current user
  Future<List<EmergencyContact>> getEmergencyContacts() async {
    if (_uid.isEmpty) return [];

    final snap = await _db
        .collection('users')
        .doc(_uid)
        .collection('emergency_contacts')
        .orderBy('createdAt', descending: false)
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return EmergencyContact.fromMap(data);
    }).toList();
  }

  /// Add a new emergency contact
  Future<void> addEmergencyContact(EmergencyContact contact) async {
    if (_uid.isEmpty) throw Exception('User not logged in.');

    await _db
        .collection('users')
        .doc(_uid)
        .collection('emergency_contacts')
        .add({
      ...contact.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update existing emergency contact
  Future<void> updateEmergencyContact(EmergencyContact contact) async {
    if (_uid.isEmpty) throw Exception('User not logged in.');
    if (contact.id.isEmpty) throw Exception('Contact ID is missing.');

    await _db
        .collection('users')
        .doc(_uid)
        .collection('emergency_contacts')
        .doc(contact.id)
        .update({
      'name': contact.name,
      'phone': contact.phone,
      'relation': contact.relation,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete an emergency contact
  Future<void> deleteEmergencyContact(String contactId) async {
    if (_uid.isEmpty) throw Exception('User not logged in.');
    if (contactId.isEmpty) throw Exception('Contact ID is missing.');

    await _db
        .collection('users')
        .doc(_uid)
        .collection('emergency_contacts')
        .doc(contactId)
        .delete();
  }

  /// Stream of emergency contacts (real-time updates)
  Stream<List<EmergencyContact>> contactsStream() {
    if (_uid.isEmpty) return const Stream.empty();

    return _db
        .collection('users')
        .doc(_uid)
        .collection('emergency_contacts')
        .orderBy('createdAt')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return EmergencyContact.fromMap(data);
    }).toList());
  }
}