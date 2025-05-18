// lib/dtos/result_dto.dart

import '../model/result_model.dart';
import 'participant_dto.dart';
import 'race_dto.dart';

class ResultDTO {
  final ParticipantDTO participant;
  final RaceDTO race;
  final String finishTime;
  final String swimmingTime;
  final String bikingTime;
  final String runningTime;

  ResultDTO({
    required this.participant,
    required this.race,
    required this.finishTime,
    required this.swimmingTime,
    required this.bikingTime,
    required this.runningTime,
  });

  // From JSON to DTO
  factory ResultDTO.fromJson(Map<String, dynamic> json) {
    return ResultDTO(
      participant: ParticipantDTO.fromJson(Map<String, dynamic>.from(json['participant'])),
      race: RaceDTO.fromJson(Map<String, dynamic>.from(json['race'])),
      finishTime: json['finishTime'],
      swimmingTime: json['swimmingTime'],
      bikingTime: json['bikingTime'],
      runningTime: json['runningTime'],
    );
  }

  // From DTO to JSON
  static Map<String, dynamic> toJson(Result result) {
    return {
      'participant': ParticipantDTO.toJson(result.participant),
      'race': RaceDTO.toJson(result.race),
      'finishTime': result.finishTime,
      'swimmingTime': result.swimmingTime,
      'bikingTime': result.bikingTime,
      'runningTime': result.runningTime,
    };
  }

  Result toModel() {
    return Result(
      participant: participant.toModel(),
      race: race.toModel(),
      finishTime: finishTime,
      swimmingTime: swimmingTime,
      bikingTime: bikingTime,
      runningTime: runningTime,
    );
  }
}
