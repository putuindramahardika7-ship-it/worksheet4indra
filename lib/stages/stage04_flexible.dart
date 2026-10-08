import 'package:flutter/material.dart';
import '../identity.dart';

class Stage04Page extends StatefulWidget {
  const Stage04Page({super.key});

  @override
  State<Stage04Page> createState() => _Stage04PageState();
}

class _Stage04PageState extends State<Stage04Page> {
  bool useWrap = true;

  final List<String> skills = const [
    'Dart',
    'Flutter',
    'Git',
    'UI Design',
    'JSON',
    'Navigation',
    'Responsive',
    'State',
  ];

  Widget buildBox(String label, Color color) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      color: color,
      child: Text(label, style: const TextStyle(fontSize: 20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chips = skills.map((e) => Chip(label: Text(e))).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4 - Expanded & Wrap')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentId - $studentName'),
            const SizedBox(height: 16),
            const Text('Expanded flex 2 : 1'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(flex: 2, child: buildBox('A (flex 2)', Colors.blue.shade200)),
                const SizedBox(width: 8),
                Expanded(child: buildBox('B (flex 1)', Colors.green.shade200)),
              ],
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Pakai Wrap (matikan = Row biasa)'),
              value: useWrap,
              onChanged: (v) => setState(() => useWrap = v),
            ),
            const SizedBox(height: 8),
            useWrap
                ? Wrap(spacing: 8, runSpacing: 8, children: chips)
                : Row(children: chips),
          ],
        ),
      ),
    );
  }
}
