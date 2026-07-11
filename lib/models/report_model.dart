import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String? id;
  String name;
  int age;
  String description;
  String lastSeenLocation;
  DateTime lastSeenDate;
  String imageUrl;
  String status;
  String reportedBy;

  ReportModel({
    this.id,
    required this.name,
    required this.age,
    required this.description,
    required this.lastSeenLocation,
    required this.lastSeenDate,
    required this.imageUrl,
    required this.status,
    required this.reportedBy,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'description': description,
      'lastSeenLocation': lastSeenLocation,
      'lastSeenDate': lastSeenDate,
      'imageUrl': imageUrl,
      'status': status,
      'reportedBy': reportedBy,
    };
  }


  factory ReportModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ReportModel(
      id: doc.id,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      description: data['description'] ?? '',
      lastSeenLocation: data['lastSeenLocation'] ?? '',
      lastSeenDate: (data['lastSeenDate'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'] ?? '',
      status: data['status'] ?? 'Missing',
      reportedBy: data['reportedBy'] ?? '',
    );
  }
}