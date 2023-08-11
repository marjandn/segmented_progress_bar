import 'package:flutter/material.dart';
import 'package:segmented_progress_bar/segmented_progress_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  List<ProgressSegment> get socialSegments => [
        ProgressSegment(value: 5, color: Colors.pink, label: 'Instagram \n 50%'),
        ProgressSegment(
            value: 3, color: Colors.indigo, label: 'Facebook \n 30%', isAbove: true, labelPadding: 20),
        ProgressSegment(value: 1, color: Colors.redAccent, label: 'Threads \n 10%'),
        ProgressSegment(
            value: 3, color: Colors.lightBlue, label: 'Tweeter \n 20%', isAbove: true, labelPadding: 20),
      ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Segmented Progress Bar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Center(
        child: SegmentedProgressBar(
          segments: socialSegments,
        ),
      ),
    );
  }
}
