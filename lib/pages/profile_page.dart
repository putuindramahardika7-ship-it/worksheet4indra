import 'package:flutter/material.dart';
import '../identity.dart';
import '../widgets/identity_banner.dart';
import '../widgets/feedback_form.dart';

/// Halaman Profil — Worksheet 5
/// Menampilkan identitas mahasiswa (IdentityBanner dengan foto profil)
/// dan Form Feedback lengkap dengan validasi, konfirmasi dialog, dan loading state.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Identitas Mahasiswa ──
              const IdentityBanner(),
              const SizedBox(height: 16),

              // ── Info singkat mahasiswa ──
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informasi Mahasiswa',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Divider(height: 16),
                      _InfoRow(icon: Icons.person, label: 'Nama', value: studentName),
                      const SizedBox(height: 8),
                      _InfoRow(icon: Icons.badge, label: 'NIM', value: studentId),
                      const SizedBox(height: 8),
                      const _InfoRow(
                          icon: Icons.school,
                          label: 'Mata Kuliah',
                          value: 'Pemrograman Mobile'),
                      const SizedBox(height: 8),
                      const _InfoRow(
                          icon: Icons.book,
                          label: 'Worksheet',
                          value: 'Worksheet 5 – Responsive Layout & Navigation'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Form Feedback ──
              Text('Form Feedback',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const FeedbackForm(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
