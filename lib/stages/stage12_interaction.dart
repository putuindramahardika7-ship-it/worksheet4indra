import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../identity.dart';
import '../widgets/course_card.dart';

class Stage12Page extends StatefulWidget {
  const Stage12Page({super.key});

  @override
  State<Stage12Page> createState() => _Stage12PageState();
}

class _Stage12PageState extends State<Stage12Page> {
  final Set<String> favorites = {};
  bool altColor = false;

  void toggleFavorite(String code) {
    setState(() {
      if (favorites.contains(code)) {
        favorites.remove(code);
      } else {
        favorites.add(code);
      }
    });
  }

  void showInfo(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course['title'] as String,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Dosen: ${course['lecturer']}'),
            Text('${course['description']}'),
            const SizedBox(height: 8),
            const Text('$studentId - $studentName'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 12 - Interaction')),
      body: Column(
        children: [
          GestureDetector(
            onDoubleTap: () => setState(() => altColor = !altColor),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: altColor ? Colors.orange.shade100 : Colors.blue.shade100,
              child: const Text(
                '$studentId - $studentName\nDouble tap area ini untuk ganti warna',
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: courses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final course = courses[index];
                final code = course['code'] as String;
                return SizedBox(
                  height: 120,
                  child: CourseCard(
                    course: course,
                    isFavorite: favorites.contains(code),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tap: ${course['title']}')),
                      );
                    },
                    onLongPress: () => showInfo(course),
                    onFavoriteToggle: () => toggleFavorite(code),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
