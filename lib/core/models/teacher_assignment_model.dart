

class TeacherAssignment {
  String id;
  String teacherId; // Clé étrangère vers 'teachers'
  String subjectId; // Clé étrangère vers 'subjects'
  String classId; // Clé étrangère vers 'classes'
  String academicYear;
  String term; // "Trimestre 1", "Semestre 1"
  // Champs optionnels (si tu as besoin de stocker des infos supplémentaires sur l'assignation) :
  // String room;      // Salle de classe
  // DateTime startDate;
  // DateTime endDate;

  TeacherAssignment({
    required this.id,
    required this.teacherId,
    required this.subjectId,
    required this.classId,
    required this.academicYear,
    required this.term,
    // this.room,
    // this.startDate,
    // this.endDate,
  });

  factory TeacherAssignment.fromFirestore(Map<String, dynamic> data, String id) {
    return TeacherAssignment(
      id: id,
      teacherId: data['teacherId'] ?? '',
      subjectId: data['subjectId'] ?? '',
      classId: data['classId'] ?? '',
      academicYear: data['academicYear'] ?? '',
      term: data['term'] ?? '',
      // room: data['room'],
      // startDate: (data['startDate'] as Timestamp)?.toDate(),
      // endDate: (data['endDate'] as Timestamp)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teacherId': teacherId,
      'subjectId': subjectId,
      'classId': classId,
      'academicYear': academicYear,
      'term': term,
      // 'room': room,
      // 'startDate': startDate,
      // 'endDate': endDate,
    };
  }
}