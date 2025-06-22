class School {
  final String id;
  final String name;
  final String schoolYear;
  final String tariffPlan;
  final List<String> installmentGridIds;

  School({
    required this.id,
    required this.name,
    required this.schoolYear,
    required this.tariffPlan,
    this.installmentGridIds = const [], // par défaut vide
  });

  factory School.fromMap(Map<String, dynamic> map, String id) {
    return School(
      id: id,
      name: map['name'] ?? '',
      schoolYear: map['schoolYear'] ?? '',
      tariffPlan: map['tariffPlan'] ?? 'standard',
      installmentGridIds: List<String>.from(map['installmentGridIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'schoolYear': schoolYear,
      'tariffPlan': tariffPlan,
      'installmentGridIds': installmentGridIds,
    };
  }
}
