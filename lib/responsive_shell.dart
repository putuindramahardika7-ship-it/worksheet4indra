import 'package:flutter/material.dart';
import 'identity.dart';
import 'pages/courses_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _index = 0;
  final Set<String> _favorites = {};

  void _setFavorite(String code, bool value) {
    setState(() {
      if (value) {
        _favorites.add(code);
      } else {
        _favorites.remove(code);
      }
    });
  }

  Widget _currentPage() {
    switch (_index) {
      case 0:
        return HomePage(
          favoriteCount: _favorites.length,
          onOpenCourses: () => setState(() => _index = 1),
        );
      case 1:
        return CoursesPage(
          favorites: _favorites,
          onSetFavorite: _setFavorite,
        );
      default:
        return const ProfilePage();
    }
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      toolbarHeight: 64,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Course Explorer'),
          Text('$studentId - $studentName', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 840;

        if (!isWide) {
          return Scaffold(
            appBar: _appBar(),
            body: _currentPage(),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
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

        return Scaffold(
          appBar: _appBar(),
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.school_outlined),
                    selectedIcon: Icon(Icons.school),
                    label: Text('Courses'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline),
                    selectedIcon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: _currentPage()),
            ],
          ),
        );
      },
    );
  }
}
