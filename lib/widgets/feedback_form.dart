import 'package:flutter/material.dart';
import '../identity.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: studentName);
  final _idController = TextEditingController(text: studentId);
  final _commentController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Dialog konfirmasi sebelum aksi penting
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Kirim feedback ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulasi loading
    if (!mounted) return; // cegah setState after dispose

    setState(() => _loading = false);
    _commentController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feedback terkirim - $studentId - $studentName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nama'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _idController,
            decoration: const InputDecoration(labelText: 'NIM'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'NIM wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Komentar',
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().length < 5)
                ? 'Komentar minimal 5 karakter'
                : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton(
                onPressed: _loading ? null : _submit, // cegah klik ganda
                child: const Text('Kirim Feedback'),
              ),
              const SizedBox(width: 16),
              if (_loading) const CircularProgressIndicator(),
            ],
          ),
        ],
      ),
    );
  }
}
