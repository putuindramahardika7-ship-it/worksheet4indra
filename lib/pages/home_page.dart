import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../widgets/identity_banner.dart';

class HomePage extends StatelessWidget {
  final int favoriteCount;
  final VoidCallback onOpenCourses;

  const HomePage({
    super.key,
    required this.favoriteCount,
    required this.onOpenCourses,
  });

  static const List<String> _skills = [
    'Dart',
    'Flutter',
    'Responsive',
    'Navigation',
    'Forms',
    'Git',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IdentityBanner(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _StatCard(
                        label: 'Total Course', value: '${courses.length}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(label: 'Favorit', value: '$favoriteCount'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Skill yang dipelajari',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skills.map((s) => Chip(label: Text(s))).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onOpenCourses,
                icon: const Icon(Icons.school),
                label: const Text('Lihat Courses'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            Text(label),
          ],
        ),
      ),
    );
  }
}
