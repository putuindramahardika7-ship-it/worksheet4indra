import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onFavoriteToggle;

  const CourseCard({
    super.key,
    required this.course,
    this.isFavorite = false,
    this.onTap,
    this.onLongPress,
    this.onFavoriteToggle,
  });

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return 'Selesai';
      case 'active':
        return 'Aktif';
      case 'planned':
        return 'Rencana';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return Colors.green;
      case 'active':
        return Colors.orange;
      case 'planned':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'done':
        return Icons.check_circle;
      case 'active':
        return Icons.sync;
      case 'planned':
        return Icons.schedule;
      default:
        return Icons.bookmark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = course['code'] as String;
    final status = (course['status'] as String?) ?? '';
    final color = _statusColor(status);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                foregroundColor: color,
                child: Text(
                  code.length >= 2 ? code.substring(0, 2) : code,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$code - ${course['credits']} SKS',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(_statusIcon(status), size: 13, color: color),
                        const SizedBox(width: 4),
                        Text(
                          _formatStatus(status),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onFavoriteToggle != null)
                IconButton(
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
