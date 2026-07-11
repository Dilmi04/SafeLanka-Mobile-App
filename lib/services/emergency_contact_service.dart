import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safelanka/models/emergency_contact_model.dart';

class EmergencyContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  // ─── Add Contact ──────────────────────────────────────────────────────────
  Future<void> addContact({
    required String name,
    required String phone,
    required String relationship,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('emergency_contacts')
        .add({
      'name': name,
      'phone': phone,
      'relation': relationship,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ─── Get All Contacts ─────────────────────────────────────────────────────
  Future<List<EmergencyContact>> getContacts() async {
    if (_uid.isEmpty) return [];

    final snap = await _firestore
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

  // ─── Update Contact ───────────────────────────────────────────────────────
  Future<void> updateContact({
    required String contactId,
    required String name,
    required String phone,
    required String relationship,
  }) async {
    if (_uid.isEmpty) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('emergency_contacts')
        .doc(contactId)
        .update({
      'name': name,
      'phone': phone,
      'relation': relationship,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ─── Delete Contact ───────────────────────────────────────────────────────
  Future<void> deleteContact(String contactId) async {
    if (_uid.isEmpty) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('emergency_contacts')
        .doc(contactId)
        .delete();
  }

  // ─── Stream of Contacts (real-time) ──────────────────────────────────────
  Stream<List<EmergencyContact>> contactsStream() {
    if (_uid.isEmpty) return const Stream.empty();

    return _firestore
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