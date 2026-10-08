import 'package:flutter/material.dart';
import '../identity.dart';

class Stage06Page extends StatefulWidget {
  const Stage06Page({super.key});

  @override
  State<Stage06Page> createState() => _Stage06PageState();
}

class _Stage06PageState extends State<Stage06Page> {
  bool useScroll = true;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('$studentId - $studentName'),
        const SizedBox(height: 16),
        for (final label in [
          'Nama lengkap',
          'NIM',
          'Email',
          'Nomor HP',
          'Alamat',
          'Kota',
          'Kode pos',
          'Hobi',
          'Catatan',
        ]) ...[
          TextField(decoration: InputDecoration(labelText: label)),
          const SizedBox(height: 16),
        ],
        FilledButton(onPressed: () {}, child: const Text('Simpan')),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6 - Scroll'),
        actions: [
          Switch(
            value: useScroll,
            onChanged: (v) => setState(() => useScroll = v),
          ),
        ],
      ),
      body: useScroll
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: content,
            )
          : Padding(padding: const EdgeInsets.all(16), child: content),
    );
  }
}
