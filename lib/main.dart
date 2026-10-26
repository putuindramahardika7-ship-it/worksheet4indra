import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/course.dart'; // Import model Course

const String studentName = 'Putu Indra Mahardika';
const String studentId = '2415051003';

// =========================================================================
// TAHAP 2 & 3: URL Endpoint dan Fungsi HTTP GET dengan Model
// =========================================================================
const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

Future<void> fetchCourses() async {
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // TAHAP 3: Mengonversi JSON menjadi List<Course>
      final List<Course> fetchedCourses = data.map((json) => Course.fromJson(json)).toList();
      debugPrint('Berhasil GET! Jumlah course dari API: ${fetchedCourses.length}');
      if (fetchedCourses.isNotEmpty) {
        debugPrint('Contoh course pertama: ${fetchedCourses[0].title} - Status: ${fetchedCourses[0].status}');
      }
    } else {
      debugPrint('Gagal! Status HTTP: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Terjadi error jaringan: $e');
  }
}
// =========================================================================

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const CourseExplorerV2App(),
    ),
  );
}

// -------------------------------------------------------------------------
// TAHAP 3: CourseProvider menggunakan Model Course
// -------------------------------------------------------------------------
class CourseProvider extends ChangeNotifier {
  final List<Course> _courses = [
    Course(code: 'MOB01', title: 'Git & GitHub', credits: 2, status: 'active', isFavorite: false),
    Course(code: 'MOB02', title: 'Dart Fundamentals', credits: 2, status: 'planned', isFavorite: false),
    Course(code: 'MOB03', title: 'Flutter UI Fundamentals', credits: 3, status: 'done', isFavorite: true),
    Course(code: 'MOB04', title: 'Responsive Layout', credits: 3, status: 'planned', isFavorite: false),
    Course(code: 'MOB05', title: 'State Management', credits: 3, status: 'planned', isFavorite: false),
  ];

  List<Course> get courses => _courses;

  int get favoriteCount => _courses.where((c) => c.isFavorite).length;

  void toggleFavorite(String code) {
    final course = _courses.firstWhere((element) => element.code == code);
    course.isFavorite = !course.isFavorite;
    notifyListeners();
  }
}

class CourseExplorerV2App extends StatelessWidget {
  const CourseExplorerV2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2 - Tahap 3',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ProviderScreen(),
    );
  }
}

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3: Model Dart JSON'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId\n$studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Kursus Favorit:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${courseProvider.favoriteCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Daftar Kursus (Data dari Model):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: courseProvider.courses.length,
                itemBuilder: (context, index) {
                  final course = courseProvider.courses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      // TAHAP 3: Menampilkan status di UI
                      subtitle: Text('Kode: ${course.code} | SKS: ${course.credits} | Status: ${course.status.toUpperCase()}'),
                      trailing: IconButton(
                        icon: Icon(course.isFavorite ? Icons.favorite : Icons.favorite_border, color: course.isFavorite ? Colors.red : Colors.grey),
                        onPressed: () {
                          context.read<CourseProvider>().toggleFavorite(course.code);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchCourses,
        child: const Icon(Icons.download),
      ),
    );
  }
}