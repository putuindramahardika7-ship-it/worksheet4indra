import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../identity.dart';

class DemoPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool showCourses;

  const DemoPage({
    super.key,
    required this.title,
    required this.icon,
    this.showCourses = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Text('$studentId - $studentName'),
        ),
        Expanded(
          child: showCourses
              ? ListView(
                  children: [
                    for (final c in courses)
                      ListTile(
                        title: Text(c['title'] as String),
                        subtitle: Text(c['code'] as String),
                      ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 64),
                      const SizedBox(height: 8),
                      Text(title,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
