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
      title: 'Course Explorer - Tahap 10',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MainNavigationPage(),
    );
  }
}

// Data statis list course
final List<Map<String, dynamic>> courses = [
  {'code': 'MOB01', 'title': 'Git & GitHub', 'credits': 2, 'status': 'Done'},
  {'code': 'MOB02', 'title': 'Dart Fundamentals', 'credits': 2, 'status': 'Done'},
  {'code': 'MOB03', 'title': 'Flutter UI Fundamentals', 'credits': 3, 'status': 'Done'},
  {'code': 'MOB04', 'title': 'Responsive Layout', 'credits': 3, 'status': 'Active'},
  {'code': 'MOB05', 'title': 'Navigation & Interaction', 'credits': 3, 'status': 'Planned'},
];

// -----------------------------------------
// TAHAP 10: StatefulWidget untuk Mengelola Tab Utama
// -----------------------------------------
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai index tab
  final List<Widget> pages = [
    const HomePage(),
    const CoursesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      // TAHAP 10: NavigationBar untuk navigasi bawah utama
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------
// Tab 1: HomePage
// -----------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home - Course Explorer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentId - $studentName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Selamat datang di aplikasi Course Explorer! Gunakan menu navigasi di bagian bawah untuk berpindah halaman.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------
// Tab 2: CoursesPage
// -----------------------------------------
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Courses')),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              title: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Kode: ${course['code']} | Status: ${course['status']}'),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------
// Tab 3: ProfilePage
// -----------------------------------------
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(height: 20),
            Text(
              studentName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'NIM: $studentId',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kelas: Mobile Programming',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}