import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../identity.dart';

class Stage09Page extends StatefulWidget {
  const Stage09Page({super.key});

  @override
  State<Stage09Page> createState() => _Stage09PageState();
}

class _Stage09PageState extends State<Stage09Page> {
  Future<void> _openDetail(Map<String, dynamic> course) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => _DetailPage(course: course)),
    );

    if (!mounted) return; // aman setelah await
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${course['title']} dipilih - $studentId'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 9 - Return Data')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: const Text('$studentId - $studentName'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course['title'] as String),
                  subtitle: Text(course['code'] as String),
                  onTap: () => _openDetail(course),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const _DetailPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course['title'] as String)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kode: ${course['code']}'),
            const Text('$studentId - $studentName'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true), // kirim true
              icon: const Icon(Icons.favorite),
              label: const Text('Pilih / Favorite'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context), // result = null
              child: const Text('Kembali tanpa memilih'),
            ),
          ],
        ),
      ),
    );
  }
}
