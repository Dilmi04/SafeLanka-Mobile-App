import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/report_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Future<String> uploadImage(XFile imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('reports/images/$fileName');

      UploadTask uploadTask;
      if (kIsWeb) {

        Uint8List bytes = await imageFile.readAsBytes();
        uploadTask = ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      } else {

        uploadTask = ref.putFile(File(imageFile.path));
      }

      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }


  Future<void> addReport(ReportModel report) async {
    try {
      await _db.collection('reports').add(report.toMap());
    } catch (e) {
      print("Error adding report: $e");
    }
  }


  Stream<List<ReportModel>> getReports() {
    return _db.collection('reports').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ReportModel.fromFirestore(doc)).toList());
  }


  Future<void> updateReport(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('reports').doc(id).update(data);
    } catch (e) {
      print("Error updating report: $e");
    }
  }


  Future<void> deleteReport(String id) async {
    try {
      await _db.collection('reports').doc(id).delete();
    } catch (e) {
      print("Error deleting report: $e");
    }
  }
}
