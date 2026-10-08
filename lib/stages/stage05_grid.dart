import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../identity.dart';
import '../widgets/course_card.dart';

int columnsFor(double width) {
  if (width < 600) return 1;
  if (width < 840) return 2;
  return 3;
}

class Stage05Page extends StatelessWidget {
  const Stage05Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 5 - GridView')),
      body: Column(
        children: [
          // Header identitas selalu terlihat
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: const Text('$studentId - $studentName'),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cols = columnsFor(constraints.maxWidth);
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 130, // tinggi kartu tetap -> tidak overflow
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) =>
                      CourseCard(course: courses[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
