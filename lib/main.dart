import 'package:flutter/material.dart';

const String studentName = 'Putu Indra Mahardika';
const String studentId = '2415051003';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer - Tahap 5',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const Tahap5Page(),
    );
  }
}

// Data statis list course
final List<Map<String, dynamic>> courses = [
  {'code': 'MOB01', 'title': 'Git & GitHub', 'credits': 2},
  {'code': 'MOB02', 'title': 'Dart Fundamentals', 'credits': 2},
  {'code': 'MOB03', 'title': 'Flutter UI Fundamentals', 'credits': 3},
  {'code': 'MOB04', 'title': 'Responsive Layout', 'credits': 3},
  {'code': 'MOB05', 'title': 'Navigation & Interaction', 'credits': 3},
  {'code': 'MOB06', 'title': 'State Management', 'credits': 3},
];

class Tahap5Page extends StatelessWidget {
  const Tahap5Page({super.key});

  // Fungsi untuk menentukan jumlah kolom berdasarkan lebar constraint
  int columnsFor(double width) {
    if (width < 600) return 1; // Compact
    if (width < 840) return 2; // Medium
    return 3;                  // Expanded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5: Responsive GridView'),
      ),
      // LayoutBuilder membaca constraint ruang yang tersedia dari parent
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Identitas Mahasiswa wajib tampil
                const Text(
                  '$studentId - $studentName',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lebar Area: ${constraints.maxWidth.toStringAsFixed(0)} px | Kolom Aktif: ${columnsFor(constraints.maxWidth)}',
                  style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                
                // GridView Responsif dibungkus Expanded agar mengisi sisa ruang bawah
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnsFor(constraints.maxWidth),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3, // Mengatur rasio lebar/tinggi kartu
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        elevation: 3,
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Kode: ${course['code']} | SKS: ${course['credits']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}