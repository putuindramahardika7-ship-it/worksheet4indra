import 'package:flutter/material.dart';
import 'responsive_shell.dart';

// UNTUK PENGUJIAN / SCREENSHOT PER TAHAP:
// Cukup uncomment import tahap di bawah dan ganti nilai 'home:' sesuai tahap tersebut.
//
// import 'stages/stage01_fixed_width.dart';
// import 'stages/stage02_mediaquery.dart';
// import 'stages/stage03_layoutbuilder.dart';
// import 'stages/stage04_flexible.dart';
// import 'stages/stage05_grid.dart';
// import 'stages/stage06_scroll.dart';
// import 'stages/stage07_navigation.dart';
// import 'stages/stage08_pass_data.dart';
// import 'stages/stage09_return_data.dart';
// import 'stages/stage10_navbar.dart';
// import 'stages/stage11_adaptive_nav.dart';
// import 'stages/stage12_interaction.dart';
// import 'stages/stage13_form.dart';
// import 'stages/stage14_feedback.dart';
// import 'stages/stage16_debug.dart';

void main() => runApp(const CourseExplorerApp());

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const ResponsiveShell(), // Tahap 15 (Final App)
    );
  }
}