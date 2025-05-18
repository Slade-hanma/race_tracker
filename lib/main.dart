// lib/main.dart


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screen/home/authentication.dart';
import '../provider/selection_provider.dart';
import 'provider/notification_provider.dart';
import 'provider/stopwatch_provider.dart';
import '../provider/participant_provider.dart';
import '../provider/result_provider.dart';
import '../provider/race_provider.dart';
import '../provider/race_status_provider.dart';

import 'repository/Mock_Repo/firebase_base_repo.dart';
import 'repository/Mock_Repo/firebase_participant_repo.dart';
import 'repository/Mock_Repo/firebase_race_repo.dart';
import 'repository/Mock_Repo/firebase_result_repo.dart';
import 'repository/Mock_Repo/firebase_race_status_repo.dart';
import 'repository/Mock_Repo/firebase_swatch_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add your Firebase configuration here
  const FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: 'AIzaSyCNdaw3wBxi_YRrC8s7DkAHnUoMU1zEXj0',
    authDomain: 'race-tracking-app-c2e54.firebaseapp.com',
    databaseURL:
        'https://race-tracking-app-c2e54-default-rtdb.asia-southeast1.firebasedatabase.app',
    projectId: 'race-tracking-app-c2e54',
    storageBucket: 'race-tracking-app-c2e54.firebasestorage.app',
    messagingSenderId: '120901742932',
    appId: '1:120901742932:web:8cc8e202c9eb49634058c1',
    measurementId: 'G-H7BY4HCQR4',
  );

  // Initialize Firebase with the provided options
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ParticipantProvider(FirebaseParticipantRepo()),
        ),
        ChangeNotifierProvider(create: (_) => RaceProvider(FirebaseRaceRepo())),
        ChangeNotifierProvider(
          create: (_) => ResultProvider(resultRepo: FirebaseResultRepo()),
        ),
        ChangeNotifierProvider(create: (_) => SelectionProvider()),
        ChangeNotifierProvider(
          create: (_) => RaceStatusProvider(FirebaseRaceStatusRepo()),
        ),
        ChangeNotifierProvider(
          create:
              (_) => StopwatchProvider(FirebaseSwatchRepo(FirebaseBaseRepo())),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ), 
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Race Tracker', style: TextStyle(color: Colors.white)),
        //   backgroundColor: Color(0xFF5C6BC0),
        // ),
        body: AuthenticationScreen(),
        
      ),
    );
  }
}
