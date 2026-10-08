import 'package:flutter/material.dart';
import '../data/courses.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatelessWidget {
  final Set<String> favorites;
  final void Function(String code, bool value) onSetFavorite;

  const CoursesPage({
    super.key,
    required this.favorites,
    required this.onSetFavorite,
  });

  int _columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

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
        content: Text(result
            ? '${course['title']} ditambahkan ke favorit'
            : '${course['title']} dihapus dari favorit'),
      ),
    );
  }

  void _showInfo(BuildContext context, Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(course['code'] as String),
        content: Text(
            '${course['title']}\nDosen: ${course['lecturer']}\n\n${course['description']}'),
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${courses.length} course - $cols kolom - '
                  '${favorites.length} favorit',
                ),
              ),
            ),
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
                    onLongPress: () => _showInfo(context, course),
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
