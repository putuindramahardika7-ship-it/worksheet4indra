import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

/// Halaman Courses — Worksheet 5
/// Menampilkan daftar mata kuliah dalam GridView responsif.
/// Jumlah kolom menyesuaikan lebar layar menggunakan LayoutBuilder.
/// Mendukung tap → navigasi ke detail, long-press → dialog info,
/// dan toggle favorit dengan umpan balik SnackBar.
class CoursesPage extends StatelessWidget {
  final Set<String> favorites;
  final void Function(String code, bool value) onSetFavorite;

  const CoursesPage({
    super.key,
    required this.favorites,
    required this.onSetFavorite,
  });

  /// Menentukan jumlah kolom berdasarkan lebar layar (breakpoint).
  int _columnsFor(double width) {
    if (width < 600) return 1;   // Compact
    if (width < 840) return 2;   // Medium
    return 3;                    // Expanded
  }

  /// Navigasi ke halaman detail dan proses nilai balik (favorit).
  Future<void> _openDetail(
      BuildContext context, Map<String, dynamic> course) async {
    final code = course['code'] as String;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(
          course: course,
          isFavorite: favorites.contains(code),
        ),
      ),
    );
    if (result == null || !context.mounted) return;
    onSetFavorite(code, result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result
              ? '⭐ ${course['title']} ditambahkan ke favorit'
              : '${course['title']} dihapus dari favorit',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Tampilkan dialog informasi singkat saat long-press.
  void _showInfoDialog(BuildContext context, Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.info_outline),
        title: Text(course['code'] as String),
        content: Text(
          '${course['title']}\n'
          'SKS: ${course['credits']}\n'
          'Dosen: ${course['lecturer']}\n\n'
          '${course['description']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = _columnsFor(constraints.maxWidth);
        final category = constraints.maxWidth < 600
            ? 'Compact'
            : constraints.maxWidth < 840
                ? 'Medium'
                : 'Expanded';

        return Column(
          children: [
            // Header info breakpoint
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                children: [
                  const Icon(Icons.grid_view, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${courses.length} mata kuliah  ·  $cols kolom  ·  $category',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (favorites.isNotEmpty)
                    Chip(
                      label: Text('${favorites.length} favorit'),
                      avatar: const Icon(Icons.favorite, size: 14,
                          color: Colors.red),
                    ),
                ],
              ),
            ),
            // GridView responsif
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 130,
                ),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  final code = course['code'] as String;
                  final isFav = favorites.contains(code);

                  return CourseCard(
                    course: course,
                    isFavorite: isFav,
                    onTap: () => _openDetail(context, course),
                    onLongPress: () => _showInfoDialog(context, course),
                    onFavoriteToggle: () => onSetFavorite(code, !isFav),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
