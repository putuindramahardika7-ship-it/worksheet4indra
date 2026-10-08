import 'package:flutter/material.dart';
import '../identity.dart';

class Stage03Page extends StatelessWidget {
  const Stage03Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3 - LayoutBuilder')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const CompactLayout();
          } else if (constraints.maxWidth < 840) {
            return const MediumLayout();
          } else {
            return const ExpandedLayout();
          }
        },
      ),
    );
  }
}

class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Perbedaan visual: 1 kolom (panel disusun vertikal), warna biru
    return const _LayoutBody(
      label: 'Compact',
      color: Colors.blue,
      panelCount: 3,
      horizontal: false,
    );
  }
}

class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Perbedaan visual: 2 panel berdampingan, warna hijau
    return const _LayoutBody(
      label: 'Medium',
      color: Colors.green,
      panelCount: 2,
      horizontal: true,
    );
  }
}

class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Perbedaan visual: 3 panel berdampingan, warna oranye
    return const _LayoutBody(
      label: 'Expanded',
      color: Colors.orange,
      panelCount: 3,
      horizontal: true,
    );
  }
}

class _LayoutBody extends StatelessWidget {
  final String label;
  final MaterialColor color;
  final int panelCount;
  final bool horizontal;

  const _LayoutBody({
    required this.label,
    required this.color,
    required this.panelCount,
    required this.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final panels = List.generate(
      panelCount,
      (i) => Expanded(
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('Panel ${i + 1}'),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori: $label',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Text('$studentId - $studentName'),
          const SizedBox(height: 12),
          Expanded(
            child: horizontal
                ? Row(children: panels)
                : Column(children: panels),
          ),
        ],
      ),
    );
  }
}
