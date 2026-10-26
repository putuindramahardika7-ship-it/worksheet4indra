import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/course.dart';
import 'services/course_api_service.dart';
import 'widgets/error_view.dart'; // Import ErrorView yang baru dibuat

const String studentName = 'Putu Indra Mahardika';
const String studentId = '2415051003';
// Pastikan URL ini benar
const String apiBaseUrl = 'https://course-api-pearl.vercel.app'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      // TAHAP 5: Panggil loadCourses() satu kali saat provider dibuat
      create: (_) => CourseProvider()..loadCourses(),
      child: const CourseExplorerV2App(),
    ),
  );
}

// -------------------------------------------------------------------------
// TAHAP 5: Mengelola state Loading, Success, Error, dan Empty di Provider
// -------------------------------------------------------------------------
class CourseProvider extends ChangeNotifier {
  List<Course> _courses = []; // Data awal dikosongkan (tidak hardcode lagi)
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get favoriteCount => _courses.where((c) => c.isFavorite).length;

  // Fungsi mengambil data dari Service
  Future<void> loadCourses() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // Beritahu UI untuk menampilkan loading

    try {
      final service = CourseApiService(apiBaseUrl);
      _courses = await service.getCourses();
    } catch (e) {
      _error = e.toString(); // Tangkap pesan error jika gagal
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI bahwa proses selesai (sukses/gagal)
    }
  }

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
      title: 'Course Explorer v2 - Tahap 5',
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
        title: const Text('Tahap 5: Async State UI'),
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
            const Text('Daftar Kursus (Data dari API API):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            // TAHAP 5: Menampilkan UI berdasarkan State (Loading/Error/Empty/Success)
            Expanded(
              child: Builder(
                builder: (context) {
                  // 1. Loading State
                  if (courseProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // 2. Error State
                  if (courseProvider.error != null) {
                    return ErrorView(
                      message: courseProvider.error!,
                      onRetry: courseProvider.loadCourses,
                    );
                  }
                  // 3. Empty State
                  if (courseProvider.courses.isEmpty) {
                    return const Center(child: Text('Data course belum tersedia'));
                  }
                  // 4. Success State (Tampilkan ListView)
                  return ListView.builder(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // TAHAP 5: FloatingActionButton diganti menjadi tombol Refresh Manual
      floatingActionButton: FloatingActionButton(
        onPressed: courseProvider.loadCourses,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}