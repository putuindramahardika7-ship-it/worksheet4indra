import 'package:flutter/material.dart';
import '../identity.dart';

class Stage01Page extends StatefulWidget {
  const Stage01Page({super.key});

  @override
  State<Stage01Page> createState() => _Stage01PageState();
}

class _Stage01PageState extends State<Stage01Page> {
  int mode = 0;

  static const _descriptions = [
    'A: Container width 500 di dalam Column. Pada layar sempit lebarnya '
        'dibatasi parent (constraints); pada layar lebar tetap 500 sehingga '
        'ada ruang kosong.',
    'B: Container width 500 di dalam Row. Row memberi lebar tak terbatas ke '
        'child, jadi pada phone terjadi RenderFlex overflow (garis '
        'kuning-hitam).',
    'C: Solusi fleksibel: Container dibungkus Expanded, ukuran mengikuti '
        'sisa ruang.',
  ];

  Widget _demo() {
    final box = Container(
      color: Colors.amber.shade200,
      padding: const EdgeInsets.all(16),
      child: Text('$studentId - $studentName'),
    );

    switch (mode) {
      case 0:
        return Container(
          width: 500,
          color: Colors.amber.shade200,
          padding: const EdgeInsets.all(16),
          child: Text('$studentId - $studentName'),
        );
      case 1:
        return Row(
          children: [
            Container(
              width: 500,
              color: Colors.amber.shade200,
              padding: const EdgeInsets.all(16),
              child: Text('$studentId - $studentName'),
            ),
            const Text('sisa'),
          ],
        );
      default:
        return Row(
          children: [
            Expanded(child: box),
            const SizedBox(width: 8),
            const Text('sisa'),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 1 - Responsive Problem')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('A')),
                ButtonSegment(value: 1, label: Text('B')),
                ButtonSegment(value: 2, label: Text('C')),
              ],
              selected: {mode},
              onSelectionChanged: (s) => setState(() => mode = s.first),
            ),
            const SizedBox(height: 12),
            Text(_descriptions[mode]),
            const SizedBox(height: 16),
            _demo(),
          ],
        ),
      ),
    );
  }
}
