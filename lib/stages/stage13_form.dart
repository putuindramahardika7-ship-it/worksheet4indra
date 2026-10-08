import 'package:flutter/material.dart';
import '../identity.dart';

class Stage13Page extends StatefulWidget {
  const Stage13Page({super.key});

  @override
  State<Stage13Page> createState() => _Stage13PageState();
}

class _Stage13PageState extends State<Stage13Page> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: studentName);
  final idController = TextEditingController(text: studentId);
  final commentController = TextEditingController();
  String? result;

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      setState(() {
        result = 'Terima kasih ${nameController.text} '
            '(${idController.text}). Komentar: ${commentController.text}';
      });
    } else {
      setState(() => result = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 13 - Form & Validasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: commentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Komentar minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: submit, child: const Text('Kirim')),
              if (result != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(result!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
