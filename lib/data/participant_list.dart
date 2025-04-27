// import '../model/participant_model.dart';
// import '../model/race_model.dart';
// import '../model/result_model.dart';
// import 'package:flutter/material.dart';

// final List<Participant> participants = [
//  Participant(
//     id: 1,
//     name: "Alice Smith",
//     sex: "Female",
//     dateOfBirth: DateTime(2002, 5, 20),
//     school: "ABC High School",
//     bibNumber: "100",
//   ),
//   Participant(
//     id: 2,
//     name: "Bob Johnson",
//     sex: "Male",
//     dateOfBirth: DateTime(2001, 3, 15),
//     school: "XYZ Academy",
//     bibNumber: "101",
//   ),
//   Participant(
//     id: 3,
//     name: "Carol White",
//     sex: "Female",
//     dateOfBirth: DateTime(2003, 7, 10),
//     school: "Sunrise Secondary",
//     bibNumber: "102",
//   ),
//   Participant(
//     id: 4,
//     name: "David Brown",
//     sex: "Male",
//     dateOfBirth: DateTime(2002, 11, 5),
//     school: "Greenfield School",
//     bibNumber: "103",
//   ),
//   Participant(
//     id: 5,
//     name: "Emily Clark",
//     sex: "Female",
//     dateOfBirth: DateTime(2001, 9, 22),
//     school: "Horizon Academy",
//     bibNumber: "104",
//   ),
// ];



// // lib/race_data.dart

// final List<Race> races = [
//   Race(
//     name: "Spring Marathon",
//     raceType: "Marathon",
//     distance: 42.195,
//     date: "2025-04-31",
//     Time: " 07:00", // April 20, 2025, at 7:00 AM
//   ),
//   Race(
//     name: "Summer Sprint",
//     raceType: "Sprint",
//     distance: 5.0,
//     date: "2025-04-31",
//     Time: " 07:00", // June 15, 2025, at 9:00 AM
//   ),
//   Race(
//     name: "Fall Half Marathon",
//     raceType: "Half Marathon",
//     distance: 21.0975,
//     date: "2025-04-31",
//     Time: " 07:00", // October 10, 2025, at 8:00 AM
//   ),
// ];


// // lib/result_data.dart
// // Assuming you have a participant_data.dart file

// final List<Result> results = [
//   Result(
//     participant: participants[0], // Alice Smith
//     race: races[0], // Spring Marathon
//     finishTime: "00:00:50:20", // 3 hours 45 minutes
//   ),
//   Result(
//     participant: participants[1], // Bob Johnson
//     race: races[0], // Spring Marathon
//     finishTime: "00:00:50:20", // 4 hours 10 minutes
//   ),
//   Result(
//     participant: participants[2], // Carol White
//     race: races[1], // Summer Sprint
//     finishTime: "00:00:50:20", // 25 minutes
//   ),
//   Result(
//     participant: participants[3], // David Brown
//     race: races[2], // Fall Half Marathon
//     finishTime: "00:00:50:20", // 1 hour 45 minutes
//   ),
//   Result(
//     participant: participants[4], // Emily Clark
//     race: races[2], // Fall Half Marathon
//     finishTime: "00:00:50:20", // 2 hours 5 minutes
//   ),
// ];


// enum RaceStatus {
//   pending,
//   started,
//   finished,
// }

// extension RaceStatusExtension on RaceStatus {
//   String get label {
//     switch (this) {
//       case RaceStatus.pending:
//         return "Pending";
//       case RaceStatus.started:
//         return "Started";
//       case RaceStatus.finished:
//         return "Finished";
//     }
//   }

//   Color get backgroundColor {
//     switch (this) {
//       case RaceStatus.pending:
//         return Colors.yellow;
//       case RaceStatus.started:
//         return Colors.lightBlue;
//       case RaceStatus.finished:
//         return Colors.red;
//     }
//   }

//   Color get textColor => Colors.white;
// }
