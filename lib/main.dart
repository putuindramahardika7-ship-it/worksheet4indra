// TAHAP 0 & 2: Deklarasi awal dan identitas mahasiswa
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const String studentName = 'Putu Indra Mahardika';
const String studentId = '2415051003';

void main() {
  runApp(const MyApp());
}

// TAHAP 12: Fungsi pembaca file JSON statik dari assets
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

// TAHAP 13: StatefulWidget untuk mengelola siklus hidup data asynchronous
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // TAHAP 13: Deklarasi variabel late Future
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    // TAHAP 13: Inisialisasi Future saat widget dimuat
    studentFuture = loadStudentData();
  }

  // TAHAP 8: Reusable Widget (Fungsi buildStatCard)
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter UI Fundamentals'),
      ),
      // TAHAP 13: FutureBuilder untuk menangani UI asinkron (Loading, Error, Success)
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

          // TAHAP 11: Menghitung jumlah topik selesai dari data JSON
          final int completedCount = courses.where((c) => c['status'] == 'done').length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              // TAHAP 4: Widget Tree (Column & Children)
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TAHAP 3, 5 & 7: Asset Image, Basic Widgets, & Card Styling
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
                          // TAHAP 5 & 6: Layout dengan Row (Main/Cross Axis)
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
                  
                  // TAHAP 6 & 8: Layout Row dan Pemanggilan Reusable Widget
                  Row(
                    children: [
                      buildStatCard('$completedCount', 'Selesai', Icons.widgets),
                      buildStatCard('${courses.length}', 'Total', Icons.view_quilt),
                      buildStatCard('1', 'State', Icons.sync),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TAHAP 9: Stateful Widget untuk Interaksi Input
                  const GreetingCard(),

                  const SizedBox(height: 20),

                  // TAHAP 11: Header Ringkasan Informasi List dari JSON
                  Text(
                    'Daftar Materi ($completedCount dari ${courses.length} selesai)',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // TAHAP 10 & 11: Menampilkan List Data JSON menggunakan ListView.builder
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

// TAHAP 9: Komponen Stateful Widget untuk Interaksi Input (GreetingCard)
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