import 'package:flutter/material.dart';
import 'identity.dart';
import 'pages/home_page.dart';
import 'pages/courses_page.dart';
import 'pages/profile_page.dart';

/// ResponsiveShell — Worksheet 5
/// Menampilkan NavigationBar (mobile <840) atau NavigationRail (tablet/desktop ≥840)
/// secara adaptif menggunakan LayoutBuilder.
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  /// Set kode mata kuliah yang difavoritkan (state diangkat ke sini agar
  /// bisa dibagikan antara HomePage dan CoursesPage).
  final Set<String> _favorites = {};

  void _onFavoriteToggle(String code, bool value) {
    setState(() {
      if (value) {
        _favorites.add(code);
      } else {
        _favorites.remove(code);
      }
    });
  }

  /// Daftar destinasi navigasi (label, ikon outline, ikon aktif)
  static const List<({String label, IconData icon, IconData activeIcon})>
      _destinations = [
    (label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
    (
      label: 'Courses',
      icon: Icons.school_outlined,
      activeIcon: Icons.school
    ),
    (
      label: 'Profil',
      icon: Icons.person_outline,
      activeIcon: Icons.person
    ),
  ];

  /// Mengembalikan halaman yang aktif sesuai indeks yang dipilih.
  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return HomePage(
          favoriteCount: _favorites.length,
          onOpenCourses: () => setState(() => _selectedIndex = 1),
        );
      case 1:
        return CoursesPage(
          favorites: _favorites,
          onSetFavorite: _onFavoriteToggle,
        );
      case 2:
        return const ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  /// AppBar yang digunakan bersama oleh layout sempit maupun lebar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 64,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Explorer',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$studentId – $studentName',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 840;

        if (isWide) {
          // ── Layout Lebar: NavigationRail di sisi kiri ──
          return Scaffold(
            appBar: _buildAppBar(),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (i) =>
                      setState(() => _selectedIndex = i),
                  destinations: _destinations
                      .map(
                        (d) => NavigationRailDestination(
                          icon: Icon(d.icon),
                          selectedIcon: Icon(d.activeIcon),
                          label: Text(d.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: _buildPage()),
              ],
            ),
          );
        }

        // ── Layout Sempit: NavigationBar di bawah ──
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildPage(),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) =>
                setState(() => _selectedIndex = i),
            destinations: _destinations
                .map(
                  (d) => NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.activeIcon),
                    label: d.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
