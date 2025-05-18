// lib/models/participant_model.dart

class Participant {
  final int id;
  final String name;
  final String sex;
  final DateTime dateOfBirth;
  final String school;
  final String bibNumber;

  Participant({
    required this.id,
    required this.name,
    required this.sex,
    required this.dateOfBirth,
    required this.school,
    required this.bibNumber,
  });
}
