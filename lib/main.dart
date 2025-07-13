import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hybrid_timer/Screens/timer_screen.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Hybrid Timer App',
          theme: ThemeData.dark(),
          home: TimerScreen(),
          debugShowCheckedModeBanner: false,
        );
      }
    );
  }
}