// lib/dtos/race_dto.dart

import '../model/race_model.dart';

class RaceDTO {
  final String name;
  final String raceType;
  final double distance;
  final String date;
  final String time;

  RaceDTO({
        required this.name,
    required this.raceType,
    required this.distance,
    required this.date,
    required this.time,
  });

  // From JSON to DTO
  factory RaceDTO.fromJson(Map<String, dynamic> json) {
    return RaceDTO(
      name: json['name'],
      raceType: json['raceType'],
      distance: json['distance'],
      date: json['date'],
      time: json['time'],
    );
  }

  // From DTO to JSON
  static Map<String, dynamic> toJson(Race race) {
    return {
      'name': race.name,
      'raceType': race.raceType,
      'distance': race.distance,
      'date': race.date,
      'time': race.Time,
    };
  }

  Race toModel() {
    return Race(
      name: name,
      raceType: raceType,
      distance: distance,
      date: date,
      Time: time,
    );
  }
}
