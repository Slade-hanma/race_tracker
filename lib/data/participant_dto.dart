import '../model/participant_model.dart';

class ParticipantDTO {
  final int id;
  final String name;
  final String sex;
  final String dateOfBirth; // Store as String in Firebase, convert to DateTime when needed
  final String school;
  final String bibNumber;

  ParticipantDTO({
    required this.id,
    required this.name,
    required this.sex,
    required this.dateOfBirth,
    required this.school,
    required this.bibNumber,
  });

  // From JSON to DTO
  factory ParticipantDTO.fromJson(Map<String, dynamic> json) {
  try {
    return ParticipantDTO(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Unknown',
      sex: json['sex'] ?? 'Unknown',
      dateOfBirth: json['dateOfBirth'] ?? '',
      school: json['school'] ?? 'Unknown',
      bibNumber: json['bibNumber'] ?? 'Unknown',
    );
  } catch (e) {

    throw Exception('Failed to parse participant data');
  }
}



  

  // From DTO to JSON
  static Map<String, dynamic> toJson(Participant participant) {
    return {
      'id': participant.id,
      'name': participant.name,
      'sex': participant.sex,
      'dateOfBirth': participant.dateOfBirth.toIso8601String(),
      'school': participant.school,
      'bibNumber': participant.bibNumber,
    };
  }

  Participant toModel() {
    return Participant(
      id: id,
      name: name,
      sex: sex,
      dateOfBirth: DateTime.parse(dateOfBirth),
      school: school,
      bibNumber: bibNumber,
    );
  }

  
}
