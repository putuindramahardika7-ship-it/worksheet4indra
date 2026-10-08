import 'package:flutter/material.dart';
import '../identity.dart';

class Stage16Page extends StatefulWidget {
  const Stage16Page({super.key});

  @override
  State<Stage16Page> createState() => _Stage16PageState();
}

class _Stage16PageState extends State<Stage16Page> {
  bool fixed = false;

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 16 - Debugging')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('$studentId - $studentName'),
          ),
          SwitchListTile(
            title: const Text('Mode perbaikan (fixed)'),
            subtitle: Text(fixed ? 'Versi diperbaiki' : 'Versi rusak'),
            value: fixed,
            onChanged: (v) => setState(() => fixed = v),
          ),
          ListTile(
            title: const Text('Kasus A - Row overflow'),
            onTap: () => _open(CaseA(fixed: fixed)),
          ),
          ListTile(
            title: const Text('Kasus B - ListView di Column'),
            onTap: () => _open(CaseB(fixed: fixed)),
          ),
          ListTile(
            title: const Text('Kasus C - Keyboard overflow'),
            onTap: () => _open(CaseC(fixed: fixed)),
          ),
          ListTile(
            title: const Text('Kasus D - Navigasi ganda'),
            onTap: () => _open(CaseD(fixed: fixed)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// KASUS A: RenderFlex overflow pada Row dengan teks panjang
// ---------------------------------------------------------------
class CaseA extends StatelessWidget {
  final bool fixed;
  const CaseA({super.key, required this.fixed});

  static const String longText =
      '$studentId - $studentName - teks sangat panjang yang tidak muat '
      'dalam satu baris pada layar phone sehingga memicu overflow';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kasus A (${fixed ? 'fixed' : 'rusak'})')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info),
            const SizedBox(width: 8),
            // RUSAK : Text(longText)
            // FIXED : Expanded membatasi lebar Text sesuai sisa ruang,
            //         sehingga teks otomatis turun ke baris berikutnya.
            fixed ? const Expanded(child: Text(longText)) : const Text(longText),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------
// KASUS B: Vertical viewport was given unbounded height
// ---------------------------------------------------------------
class CaseB extends StatelessWidget {
  final bool fixed;
  const CaseB({super.key, required this.fixed});

  @override
  Widget build(BuildContext context) {
    final list = ListView.builder(
      itemCount: 30,
      itemBuilder: (context, i) => ListTile(title: Text('Item ${i + 1}')),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Kasus B (${fixed ? 'fixed' : 'rusak'})')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('$studentId - $studentName'),
          ),
          // RUSAK : list langsung di Column -> tinggi tak terbatas -> error
          // FIXED : dibungkus Expanded -> tinggi dibatasi sisa ruang Column
          fixed ? Expanded(child: list) : list,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// KASUS C: Keyboard overflow
// ---------------------------------------------------------------
class CaseC extends StatelessWidget {
  final bool fixed;
  const CaseC({super.key, required this.fixed});

  @override
  Widget build(BuildContext context) {
    final form = Column(
      children: [
        const Text('$studentId - $studentName'),
        const SizedBox(height: 120),
        const TextField(decoration: InputDecoration(labelText: 'Nama')),
        const SizedBox(height: 120),
        const TextField(decoration: InputDecoration(labelText: 'NIM')),
        const SizedBox(height: 120),
        const TextField(decoration: InputDecoration(labelText: 'Komentar')),
        const SizedBox(height: 24),
        FilledButton(onPressed: () {}, child: const Text('Kirim')),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: Text('Kasus C (${fixed ? 'fixed' : 'rusak'})')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // RUSAK : form biasa -> saat keyboard muncul tinggi body mengecil
        //         -> bottom overflow
        // FIXED : SingleChildScrollView -> konten bisa digulir
        child: fixed ? SingleChildScrollView(child: form) : form,
      ),
    );
  }
}

// ---------------------------------------------------------------
// KASUS D: Navigasi ganda (route ter-push berkali-kali)
// ---------------------------------------------------------------
class CaseD extends StatefulWidget {
  final bool fixed;
  const CaseD({super.key, required this.fixed});

  @override
  State<CaseD> createState() => _CaseDState();
}

class _CaseDState extends State<CaseD> {
  bool _busy = false;
  int pushCount = 0;

  Future<void> _go() async {
    if (widget.fixed) {
      if (_busy) return; // guard: abaikan tap selama proses
      setState(() => _busy = true);
    }
    setState(() => pushCount++);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Halaman Tujuan')),
          body: const Center(child: Text('Tekan back untuk kembali')),
        ),
      ),
    );

    if (!mounted) return;
    if (widget.fixed) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Kasus D (${widget.fixed ? 'fixed' : 'rusak'})')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('$studentId - $studentName'),
            Text('Jumlah push: $pushCount'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _go,
              child: const Text('Buka halaman (tap cepat berkali-kali)'),
            ),
          ],
        ),
      ),
    );
  }
}
