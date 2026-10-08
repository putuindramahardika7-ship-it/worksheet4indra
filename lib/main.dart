import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Putu Indra Mahardika';
const String studentId = '2415051003';

void main() {
  runApp(const MyApp());
}

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString('assets/data/student_data.json');
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  Widget buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TAHAP 2: Mengambil data karakteristik layar
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isCompact = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter UI Fundamentals'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;
          final int completedCount = courses.where((c) => c['status'] == 'done').length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // TAHAP 2: Card Informasi MediaQuery
                  Card(
                    color: isCompact ? Colors.orange.shade100 : Colors.blue.shade100,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Layar (MediaQuery)', 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          const Divider(),
                          Text('Identitas: $studentId - $studentName'),
                          const SizedBox(height: 8),
                          Text('Lebar Layar: ${size.width.toStringAsFixed(0)} px'),
                          Text('Tinggi Layar: ${size.height.toStringAsFixed(0)} px'),
                          Text('Orientasi: $orientation'),
                          const SizedBox(height: 8),
                          Text(
                            'Kategori Layout: ${isCompact ? 'Compact (< 600px)' : 'Wide (>= 600px)'}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: isCompact ? Colors.deepOrange : Colors.blueAccent
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TAHAP 1: Uji coba layout responsif Worksheet 5
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.green.shade100,
                    child: const Text(
                      'Responsive Container\n(Flexible Width: double.infinity)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // TAHAP 3: LayoutBuilder & Breakpoint (Compact < 600, Medium 600-839, Expanded >= 840)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth = constraints.maxWidth;
                      final MaterialColor breakpointColor;
                      final String breakpointCategory;
                      final int panelCount;

                      if (maxWidth < 600) {
                        breakpointCategory = 'Compact (< 600px)';
                        breakpointColor = Colors.blue;
                        panelCount = 3;
                      } else if (maxWidth < 840) {
                        breakpointCategory = 'Medium (600 - 839px)';
                        breakpointColor = Colors.green;
                        panelCount = 2;
                      } else {
                        breakpointCategory = 'Expanded (>= 840px)';
                        breakpointColor = Colors.orange;
                        panelCount = 3;
                      }

                      final bool isHorizontal = maxWidth >= 600;

                      return Card(
                        elevation: 3,
                        color: breakpointColor.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tahap 3: LayoutBuilder & Breakpoint',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const Divider(),
                              Text('Identitas: $studentId - $studentName'),
                              const SizedBox(height: 4),
                              Text('Constraints Max Width: ${maxWidth.toStringAsFixed(0)} px'),
                              const SizedBox(height: 4),
                              Text(
                                'Breakpoint Terdeteksi: $breakpointCategory',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: breakpointColor.shade800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              isHorizontal
                                  ? Row(
                                      children: List.generate(
                                        panelCount,
                                        (i) => Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 4),
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: breakpointColor.shade100,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: breakpointColor.shade400),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Panel ${i + 1}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: breakpointColor.shade900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: List.generate(
                                        panelCount,
                                        (i) => Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: breakpointColor.shade100,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: breakpointColor.shade400),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Panel ${i + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: breakpointColor.shade900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // TAHAP 4: Expanded, Flexible, dan Wrap
                  const Tahap4Card(),
                  const SizedBox(height: 20),

                  // Card Profil
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                            radius: 46,
                            backgroundImage: AssetImage('assets/images/profile.jpg'),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            student['name'] as String, 
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                          ),
                          Text('NIM: ${student['nim']}'),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.phone_android),
                              SizedBox(width: 8),
                              Text('Mobile Programming Student'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Row(
                    children: [
                      buildStatCard('$completedCount', 'Selesai', Icons.widgets),
                      buildStatCard('${courses.length}', 'Total', Icons.view_quilt),
                      buildStatCard('1', 'State', Icons.sync),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const GreetingCard(),

                  const SizedBox(height: 20),

                  Text(
                    'Daftar Materi ($completedCount dari ${courses.length} selesai)',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index] as Map<String, dynamic>;
                      final bool isDone = course['status'] == 'done';
                      final bool isActive = course['status'] == 'active';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Icon(
                            isDone ? Icons.check_circle : (isActive ? Icons.sync : Icons.schedule),
                            color: isDone ? Colors.green : (isActive ? Colors.orange : Colors.grey),
                          ),
                          title: Text(course['title'] as String),
                          subtitle: Text('Kode: ${course['code']} | SKS: ${course['credits']}'),
                          trailing: Text(
                            isDone ? 'Selesai' : (isActive ? 'Aktif' : 'Rencana'),
                            style: TextStyle(
                              color: isDone ? Colors.green : (isActive ? Colors.orange : Colors.grey),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();
  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId\n$studentName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Masukkan pesan Anda',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  message = controller.text.trim().isEmpty
                      ? 'Input masih kosong'
                      : controller.text.trim();
                });
              },
              child: const Text('Tampilkan'),
            ),
            const SizedBox(height: 10),
            Text('Hasil: $message', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// TAHAP 4: Widget Reusable untuk Demonstrasi Expanded flex 2:1 & Wrap
class Tahap4Card extends StatefulWidget {
  const Tahap4Card({super.key});

  @override
  State<Tahap4Card> createState() => _Tahap4CardState();
}

class _Tahap4CardState extends State<Tahap4Card> {
  bool useWrap = true;

  final List<String> skills = const [
    'Dart',
    'Flutter',
    'Git',
    'UI Design',
    'JSON',
    'Navigation',
    'Responsive',
    'State',
  ];

  Widget buildBox(String label, Color color) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chips = skills.map((e) => Chip(label: Text(e))).toList();

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tahap 4: Expanded, Flexible & Wrap',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            Text('Identitas: $studentId - $studentName'),
            const SizedBox(height: 12),
            const Text(
              'Expanded flex 2 : 1',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: buildBox('A (flex 2)', Colors.blue.shade200),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: buildBox('B (flex 1)', Colors.green.shade200),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Pakai Wrap (matikan = Row biasa)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                useWrap ? 'Mode: Wrap responsif' : 'Mode: Row biasa (memicu overflow jika sempit)',
              ),
              value: useWrap,
              onChanged: (v) => setState(() => useWrap = v),
            ),
            const SizedBox(height: 8),
            useWrap
                ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: chips,
                  )
                : Row(children: chips),
          ],
        ),
      ),
    );
  }
}