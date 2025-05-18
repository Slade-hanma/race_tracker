// lib/dtos/race_status_dto.dart

import '../model/race_status_enum.dart';

class RaceStatusDTO {
  final String status;

  RaceStatusDTO({required this.status});

  RaceStatus toModel() => raceStatusFromString(status);

  factory RaceStatusDTO.fromJson(Map<String, dynamic> json) {
    return RaceStatusDTO(status: json['status']);
  }

  Map<String, dynamic> toJson() => {
        'status': status,
      };

  static RaceStatusDTO fromModel(RaceStatus model) {
    return RaceStatusDTO(status: raceStatusToString(model));
  }
}
