import 'package:flutter/material.dart';
import '../widgets/demo_page.dart';

class Stage10Page extends StatefulWidget {
  const Stage10Page({super.key});

  @override
  State<Stage10Page> createState() => _Stage10PageState();
}

class _Stage10PageState extends State<Stage10Page> {
  int currentIndex = 0;

  final List<DemoPage> pages = const [
    DemoPage(title: 'Home', icon: Icons.home),
    DemoPage(title: 'Courses', icon: Icons.school, showCourses: true),
    DemoPage(title: 'Profile', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pages[currentIndex].title)),
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
