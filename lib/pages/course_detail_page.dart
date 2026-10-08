import 'package:flutter/material.dart';
import '../identity.dart';

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course['title'] as String)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['title'] as String,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text('Kode: ${course['code']}'),
                Text('SKS: ${course['credits']}'),
                Text('Status: ${course['status']}'),
                Text('Dosen: ${course['lecturer']}'),
                const SizedBox(height: 12),
                Text(course['description'] as String),
                const Divider(height: 32),
                const Text('$studentId - $studentName'),
                const SizedBox(height: 24),
                FilledButton.icon(
                  // pop dengan result = status favorit yang diinginkan
                  onPressed: () => Navigator.pop(context, !isFavorite),
                  icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border),
                  label: Text(isFavorite
                      ? 'Hapus dari favorit'
                      : 'Jadikan favorit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
