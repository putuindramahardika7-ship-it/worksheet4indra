import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/course.dart';
import 'services/course_api_service.dart'; // Import service baru

const String studentName = 'Putu Indra Mahardika';
const String studentId = '2415051003';
// TAHAP 4: Hanya menyimpan Base URL saja
const String apiBaseUrl = 'https://course-api-pearl.vercel.app'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const CourseExplorerV2App(),
    ),
  );
}

// -------------------------------------------------------------------------
// CourseProvider menggunakan Model Course
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
      title: 'Course Explorer v2 - Tahap 4',
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
        title: const Text('Tahap 4: Service Layer'),
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
      // TAHAP 4: Memanggil method dari Service API
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final service = CourseApiService(apiBaseUrl);
            final fetchedCourses = await service.getCourses();
            debugPrint('Berhasil GET via Service! Jumlah course: ${fetchedCourses.length}');
          } catch (e) {
            debugPrint('Error: $e');
          }
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}