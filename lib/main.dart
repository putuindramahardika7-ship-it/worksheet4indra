import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'data/courses.dart' as course_data;
import 'widgets/course_card.dart';

// Identitas Mahasiswa (Worksheet 4 & 5)
const String studentName = 'Putu Indra Mahardika';
const String studentId = '2415051003';

void main() {
  runApp(const MyApp());
}

// Fungsi pembaca data JSON asinkron dari Worksheet 4
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
      title: 'Course Explorer - Learning Dashboard',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
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

  // Helper widget kartu statistik (Worksheet 4)
  Widget buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header pembatas seksi agar antarmuka rapi dan terstruktur
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TAHAP 2: Mengambil data karakteristik layar melalui MediaQuery
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isCompact = size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Course Explorer & UI Fundamentals'),
            Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        elevation: 2,
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
          final int completedCount =
              courses.where((c) => c['status'] == 'done').length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // SEKSI 1: PROFIL & STATISTIK (WORKSHEET 4)
                    // ==========================================
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 38,
                              backgroundImage:
                                  AssetImage('assets/images/profile.jpg'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student['name'] as String,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('NIM: ${student['nim']}'),
                                  const SizedBox(height: 4),
                                  const Row(
                                    children: [
                                      Icon(Icons.phone_android, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        'Mobile Programming Student',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Baris Statistik (Selesai, Total, State)
                    Row(
                      children: [
                        buildStatCard('$completedCount', 'Selesai', Icons.widgets),
                        const SizedBox(width: 8),
                        buildStatCard('${courses.length}', 'Total Materi', Icons.view_quilt),
                        const SizedBox(width: 8),
                        buildStatCard('1', 'State Aktif', Icons.sync),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ====================================================
                    // SEKSI 2: RESPONSIVE LAYOUT & BREAKPOINTS (WORKSHEET 5)
                    // ====================================================
                    _buildSectionHeader(
                      'Implementasi Responsive Layout (Tahap 1 - 5)',
                      Icons.devices,
                    ),

                    // TAHAP 1 & 2: Informasi Layar MediaQuery & Flexible Container
                    Card(
                      color: isCompact
                          ? Colors.orange.shade50
                          : Colors.blue.shade50,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tahap 1 & 2: MediaQuery & Container Fleksibel',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isCompact
                                        ? Colors.orange.shade200
                                        : Colors.blue.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isCompact ? 'Compact' : 'Wide',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: isCompact
                                          ? Colors.deepOrange.shade900
                                          : Colors.blue.shade900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 18),
                            Text('Identitas: $studentId - $studentName'),
                            const SizedBox(height: 4),
                            Text('Dimensi Layar: ${size.width.toStringAsFixed(0)} px × ${size.height.toStringAsFixed(0)} px'),
                            Text('Orientasi: $orientation'),
                            const SizedBox(height: 10),
                            // Tahap 1: Kontainer Lebar Fleksibel
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.shade400),
                              ),
                              child: const Text(
                                'Tahap 1: Responsive Container (Flexible Width: double.infinity)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // TAHAP 3: LayoutBuilder & Breakpoint
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
                          elevation: 2,
                          color: breakpointColor.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Tahap 3: LayoutBuilder & Breakpoint',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      breakpointCategory,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: breakpointColor.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 18),
                                Text('Constraints Max Width: ${maxWidth.toStringAsFixed(0)} px'),
                                const SizedBox(height: 10),
                                isHorizontal
                                    ? Row(
                                        children: List.generate(
                                          panelCount,
                                          (i) => Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 4),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: breakpointColor.shade100,
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: breakpointColor.shade300),
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
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: breakpointColor.shade100,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: breakpointColor.shade300),
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

                    const SizedBox(height: 12),

                    // TAHAP 4: Expanded, Flexible, dan Wrap
                    const Tahap4Card(),

                    const SizedBox(height: 12),

                    // TAHAP 5: GridView Responsif & CourseCard Reusable
                    Tahap5Card(coursesList: courses),

                    const SizedBox(height: 16),

                    // ====================================================
                    // SEKSI 3: INTERAKSI & LIST DETAIL (WORKSHEET 4)
                    // ====================================================
                    _buildSectionHeader(
                      'Interaktivitas State & Detail Materi (Worksheet 4)',
                      Icons.touch_app,
                    ),

                    const GreetingCard(),

                    const SizedBox(height: 12),

                    // Daftar Materi ListView dari Worksheet 4
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daftar Materi ($completedCount dari ${courses.length} selesai)',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 18),
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
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: ListTile(
                                    leading: Icon(
                                      isDone
                                          ? Icons.check_circle
                                          : (isActive ? Icons.sync : Icons.schedule),
                                      color: isDone
                                          ? Colors.green
                                          : (isActive ? Colors.orange : Colors.grey),
                                    ),
                                    title: Text(
                                      course['title'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        'Kode: ${course['code']} | SKS: ${course['credits']}'),
                                    trailing: Text(
                                      isDone
                                          ? 'Selesai'
                                          : (isActive ? 'Aktif' : 'Rencana'),
                                      style: TextStyle(
                                        color: isDone
                                            ? Colors.green
                                            : (isActive ? Colors.orange : Colors.grey),
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
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =====================================================================
// KOMPONEN WIDGET PENDUKUNG (WORKSHEET 4 & WORKSHEET 5)
// =====================================================================

// Widget GreetingCard dari Worksheet 4
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Greeting Card',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Masukkan pesan Anda',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  message = controller.text.trim().isEmpty
                      ? 'Input masih kosong'
                      : controller.text.trim();
                });
              },
              icon: const Icon(Icons.send, size: 16),
              label: const Text('Tampilkan Pesan'),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Hasil: $message',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TAHAP 4: Widget Demonstrasi Expanded flex 2:1 & Wrap
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
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chips = skills.map((e) => Chip(label: Text(e))).toList();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tahap 4: Expanded flex 2:1 & Wrap Responsif',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 18),
            const Text(
              'Expanded Rasio 2 : 1',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
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
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Pakai Wrap (matikan = Row biasa)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: Text(
                useWrap
                    ? 'Mode: Wrap responsif (chip turun otomatis)'
                    : 'Mode: Row biasa (memicu overflow jika layar sempit)',
                style: const TextStyle(fontSize: 12),
              ),
              value: useWrap,
              onChanged: (v) => setState(() => useWrap = v),
            ),
            const SizedBox(height: 6),
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

// TAHAP 5: Widget Responsive GridView dengan CourseCard (5 Mata Kuliah)
class Tahap5Card extends StatelessWidget {
  final List<dynamic>? coursesList;
  const Tahap5Card({super.key, this.coursesList});

  int columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final list = (coursesList != null && coursesList!.isNotEmpty)
        ? coursesList!
        : course_data.courses;

    return LayoutBuilder(
      builder: (context, constraints) {
        final int cols = columnsFor(constraints.maxWidth);

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tahap 5: GridView Responsif & CourseCard',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$cols Kolom Grid',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 18),
                Text(
                  'Total: ${list.length} Materi | Lebar Layar: ${constraints.maxWidth.toStringAsFixed(0)} px',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 130, // tinggi kartu tetap -> tidak overflow
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final courseMap = item is Map<String, dynamic>
                        ? item
                        : Map<String, dynamic>.from(item as Map);
                    return CourseCard(course: courseMap);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}