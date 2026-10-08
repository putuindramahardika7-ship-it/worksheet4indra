import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../widgets/identity_banner.dart';

/// Halaman Home — Worksheet 5
/// Menampilkan IdentityBanner, ringkasan statistik (Total Mata Kuliah + Favorit),
/// daftar skill dalam Wrap (demonstrasi Flexible), dan tombol navigasi ke Courses.
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
    'Responsive Layout',
    'Navigation',
    'Form & Validation',
    'State Management',
    'Git & GitHub',
    'MediaQuery',
    'LayoutBuilder',
    'GridView',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Hitung statistik dari data
    final int done = courses.where((c) => c['status'] == 'done').length;
    final int active = courses.where((c) => c['status'] == 'active').length;
    final int planned = courses.where((c) => c['status'] == 'planned').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Identitas Mahasiswa ──
              const IdentityBanner(),
              const SizedBox(height: 20),

              // ── Statistik menggunakan Expanded (Tahap 4) ──
              Text('Statistik', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _StatCard(
                      label: 'Total Mata Kuliah',
                      value: '${courses.length}',
                      icon: Icons.school,
                      color: theme.colorScheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      label: 'Favorit',
                      value: '$favoriteCount',
                      icon: Icons.favorite,
                      color: Colors.red.shade100,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Selesai',
                      value: '$done',
                      icon: Icons.check_circle,
                      color: Colors.green.shade100,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      label: 'Aktif',
                      value: '$active',
                      icon: Icons.sync,
                      color: Colors.orange.shade100,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      label: 'Rencana',
                      value: '$planned',
                      icon: Icons.schedule,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Skill List menggunakan Wrap (Tahap 4) ──
              Text('Skill yang Dipelajari',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _skills
                    .map((s) => Chip(
                          label: Text(s),
                          avatar: const Icon(Icons.code, size: 16),
                        ))
                    .toList(),
              ),

              const SizedBox(height: 24),

              // ── Tombol navigasi ke halaman Courses ──
              FilledButton.icon(
                onPressed: onOpenCourses,
                icon: const Icon(Icons.school),
                label: const Text('Lihat Semua Mata Kuliah'),
              ),

              const SizedBox(height: 16),

              // ── Info MediaQuery (Tahap 2) ──
              _MediaQueryInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget MediaQuery Info ────────────────────────────────────────────────────

class _MediaQueryInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final orientation = mq.orientation;
    final isCompact = size.width < 600;
    final category = size.width < 600
        ? 'Compact'
        : size.width < 840
            ? 'Medium'
            : 'Expanded';

    return Card(
      color: isCompact ? Colors.orange.shade50 : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.monitor, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Info Layar (MediaQuery)',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Chip(
                  label: Text(category),
                  backgroundColor:
                      isCompact ? Colors.orange.shade200 : Colors.blue.shade200,
                ),
              ],
            ),
            const Divider(height: 16),
            Text('Lebar: ${size.width.toStringAsFixed(0)} px'),
            Text('Tinggi: ${size.height.toStringAsFixed(0)} px'),
            Text(
                'Orientasi: ${orientation == Orientation.portrait ? 'Portrait' : 'Landscape'}'),
            Text('Device Pixel Ratio: ${mq.devicePixelRatio.toStringAsFixed(1)}'),
          ],
        ),
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
