import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String studentName = 'Putu Indra Mahardika';
const String studentId = '2415051003';

void main() {
  runApp(
    // TAHAP 6: Memasang ChangeNotifierProvider di tingkat atas widget tree
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const CourseExplorerV2App(),
    ),
  );
}

// -------------------------------------------------------------------------
// TAHAP 6 & 7: CourseProvider (ChangeNotifier)
// -------------------------------------------------------------------------
class CourseProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _courses = [
    {'code': 'MOB01', 'title': 'Git & GitHub', 'credits': 2, 'isFavorite': false},
    {'code': 'MOB02', 'title': 'Dart Fundamentals', 'credits': 2, 'isFavorite': false},
    {'code': 'MOB03', 'title': 'Flutter UI Fundamentals', 'credits': 3, 'isFavorite': true},
    {'code': 'MOB04', 'title': 'Responsive Layout', 'credits': 3, 'isFavorite': false},
    {'code': 'MOB05', 'title': 'State Management', 'credits': 3, 'isFavorite': false},
  ];

  List<Map<String, dynamic>> get courses => _courses;

  int get favoriteCount => _courses.where((c) => c['isFavorite'] == true).length;

  void toggleFavorite(String code) {
    final course = _courses.firstWhere((element) => element['code'] == code);
    course['isFavorite'] = !course['isFavorite'];
    notifyListeners(); // Memberitahu widget listener
  }
}

class CourseExplorerV2App extends StatelessWidget {
  const CourseExplorerV2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2 - Tahap 6 & 7',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ProviderScreen(),
    );
  }
}

class ProviderScreen extends StatelessWidget {
  const ProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TAHAP 7: Menggunakan context.watch() untuk mendengarkan perubahan total favorite
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6 & 7: Provider, Watch & Read'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            // Kartu Ringkasan menggunakan data dari context.watch()
            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Kursus Favorit:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${courseProvider.favoriteCount}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Daftar Kursus (Provider Integration):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Daftar List Kursus
            Expanded(
              child: ListView.builder(
                itemCount: courseProvider.courses.length,
                itemBuilder: (context, index) {
                  final course = courseProvider.courses[index];
                  final isFav = course['isFavorite'] as bool;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Kode: ${course['code']} | SKS: ${course['credits']}'),
                      trailing: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          // TAHAP 7: Menggunakan context.read() untuk memanggil aksi tanpa melakukan listen/rebuild pada tombol
                          context.read<CourseProvider>().toggleFavorite(course['code']);
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
    );
  }
}