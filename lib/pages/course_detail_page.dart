import 'package:flutter/material.dart';
import '../identity.dart';

/// Halaman Detail Mata Kuliah — Worksheet 5
/// Dapat diakses dari CoursesPage melalui Navigator.push.
/// Mengembalikan nilai bool (true = jadikan favorit, false = hapus favorit)
/// ke halaman sebelumnya via Navigator.pop.
class CourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;

  const CourseDetailPage({
    super.key,
    required this.course,
    required this.isFavorite,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  String _formatStatus(String s) {
    switch (s.toLowerCase()) {
      case 'done':
        return 'Selesai';
      case 'active':
        return 'Sedang Dipelajari';
      case 'planned':
        return 'Direncanakan';
      default:
        return s;
    }
  }

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'done':
        return Colors.green;
      case 'active':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String s) {
    switch (s.toLowerCase()) {
      case 'done':
        return Icons.check_circle;
      case 'active':
        return Icons.sync;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final status = (course['status'] as String?) ?? '';
    final color = _statusColor(status);

    return Scaffold(
      appBar: AppBar(
        title: Text(course['title'] as String),
        // Tombol back mengembalikan status favorit saat ini
        leading: BackButton(
          onPressed: () => Navigator.pop(context, _isFavorite),
        ),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Hapus dari favorit' : 'Jadikan favorit',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                key: ValueKey(_isFavorite),
                color: _isFavorite ? Colors.red : null,
              ),
            ),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Status Badge ──
                Row(
                  children: [
                    Icon(_statusIcon(status), color: color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _formatStatus(status),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Judul ──
                Text(
                  course['title'] as String,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // ── Detail ──
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _DetailRow(label: 'Kode', value: course['code'] as String),
                        const Divider(height: 16),
                        _DetailRow(
                            label: 'SKS',
                            value: '${course['credits']} SKS'),
                        const Divider(height: 16),
                        _DetailRow(
                            label: 'Dosen', value: course['lecturer'] as String),
                        const Divider(height: 16),
                        _DetailRow(
                            label: 'Status', value: _formatStatus(status)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Deskripsi ──
                Text('Deskripsi',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  course['description'] as String,
                  style: const TextStyle(height: 1.5),
                ),

                const SizedBox(height: 24),

                // ── Tombol Favorit ──
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      setState(() => _isFavorite = !_isFavorite);
                      // Langsung pop dengan nilai baru
                      Navigator.pop(context, _isFavorite);
                    },
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(
                      _isFavorite
                          ? 'Hapus dari Favorit'
                          : 'Jadikan Favorit',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          _isFavorite ? Colors.red : null,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Identitas Mahasiswa ──
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  '$studentId – $studentName',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
