class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String relation;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.relation,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'relation': relation,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      relation: map['relation'] ?? '',
    );
  }
}
