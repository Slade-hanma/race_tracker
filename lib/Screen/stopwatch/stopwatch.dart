// lib/screen/stopwatch/stopwatch.dart


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/stopwatch_provider.dart';

class StopwatchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StopwatchProvider>();

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF5C6BC0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  provider.displayTime,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // Buttons
          if (!provider.isRunning)
            ElevatedButton(
              onPressed: provider.start,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5C6BC0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                minimumSize: Size(150, 60), // Added minimum size
              ),
              child: Text(
                'Start',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: provider.reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 67, 108, 185).withOpacity(0.5),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    minimumSize: Size(150, 60), // Added minimum size
                  ),
                  child: Text(
                    'Reset',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 30),
                ElevatedButton(
                  onPressed: provider.stop,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    minimumSize: Size(150, 60), // Added minimum size
                  ),
                  child: Text(
                    'Stop/Continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}