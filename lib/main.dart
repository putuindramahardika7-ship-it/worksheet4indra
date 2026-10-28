import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/course.dart';
import 'services/course_supabase_service.dart';
import 'repositories/course_repository.dart';
import 'widgets/error_view.dart';
import 'screens/course_form_page.dart';

const String studentName = 'Putu Indra Mahardika';
const String studentId = '2415051003';

const String supabaseUrl = 'https://nwbggednoovhykmrcfnt.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53YmdnZWRub292aHlrbXJjZm50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxNzcwNzIsImV4cCI6MjEwODc1MzA3Mn0.Fo0Mi9QUJpuSdIXYEorwOaC3yvvfoD_qxAYoPsFligY';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  final repository = CourseRepository(CourseSupabaseService());

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..listenToCoursesStream(),
      child: const CourseExplorerV2App(),
    ),
  );
}

class CourseProvider extends ChangeNotifier {
  CourseProvider(this.repository);
  final CourseRepository repository;

  List<Course> _courses = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  StreamSubscription<List<Course>>? _coursesSubscription;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  int get favoriteCount => _courses.where((c) => c.isFavorite).length;

  // TAHAP 16: Berlangganan data Realtime dari Supabase Stream
  void listenToCoursesStream() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _coursesSubscription?.cancel();
    _coursesSubscription = repository.getCoursesStream().listen(
      (data) {
        _courses = data;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> addCourse(Course course) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await repository.createCourse(course);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateCourse(int id, Course course) async {
    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      await repository.updateCourse(id, course);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCourse(int id) async {
    _error = null;
    try {
      await repository.deleteCourse(id);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  void toggleFavorite(String code) {
    final course = _courses.firstWhere((element) => element.code == code);
    course.isFavorite = !course.isFavorite;
    notifyListeners();
  }

  @override
  void dispose() {
    _coursesSubscription?.cancel();
    super.dispose();
  }
}

class CourseExplorerV2App extends StatelessWidget {
  const CourseExplorerV2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2 - Tahap 16',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ProviderScreen(),
    );
  }
}

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  void _confirmDelete(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus course "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (course.id != null) {
                final success = await context.read<CourseProvider>().deleteCourse(course.id!);
                if (!context.mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course berhasil dihapus!'), backgroundColor: Colors.red),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus: ${context.read<CourseProvider>().error}'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16: Supabase Realtime Stream'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CourseFormPage()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('$studentId\n$studentName', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            const Text('Daftar Kursus (Realtime Live Sync):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (courseProvider.isLoading) return const Center(child: CircularProgressIndicator());
                  if (courseProvider.error != null) return ErrorView(message: courseProvider.error!, onRetry: courseProvider.listenToCoursesStream);
                  if (courseProvider.courses.isEmpty) return const Center(child: Text('Data course belum tersedia'));
                  
                  return ListView.builder(
                    itemCount: courseProvider.courses.length,
                    itemBuilder: (context, index) {
                      final course = courseProvider.courses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Kode: ${course.code} | SKS: ${course.credits} | Status: ${course.status.toUpperCase()}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CourseFormPage(courseToEdit: course)),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(context, course),
                              ),
                              IconButton(
                                icon: Icon(course.isFavorite ? Icons.favorite : Icons.favorite_border, color: course.isFavorite ? Colors.red : Colors.grey),
                                onPressed: () => context.read<CourseProvider>().toggleFavorite(course.code),
                              ),
                            ],
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
    );
  }
}