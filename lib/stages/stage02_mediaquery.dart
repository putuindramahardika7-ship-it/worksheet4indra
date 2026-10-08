import 'package:flutter/material.dart';
import '../identity.dart';

class Stage02Page extends StatelessWidget {
  const Stage02Page({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isCompact = size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 2 - MediaQuery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$studentId - $studentName',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text('Width: ${size.width.toStringAsFixed(0)}'),
            Text('Height: ${size.height.toStringAsFixed(0)}'),
            Text('Orientation: $orientation'),
            const SizedBox(height: 16),
            Text(
              isCompact ? 'Compact' : 'Wide',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
