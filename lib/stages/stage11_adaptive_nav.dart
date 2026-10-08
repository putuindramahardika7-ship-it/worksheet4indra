import 'package:flutter/material.dart';
import '../widgets/demo_page.dart';

class Stage11Page extends StatefulWidget {
  const Stage11Page({super.key});

  @override
  State<Stage11Page> createState() => _Stage11PageState();
}

class _Stage11PageState extends State<Stage11Page> {
  int selectedIndex = 0;

  final List<DemoPage> pages = const [
    DemoPage(title: 'Home', icon: Icons.home),
    DemoPage(title: 'Courses', icon: Icons.school, showCourses: true),
    DemoPage(title: 'Profile', icon: Icons.person),
  ];

  Widget buildNavigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (i) => setState(() => selectedIndex = i),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Widget buildNavigationRail() {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (i) => setState(() => selectedIndex = i),
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
        NavigationRailDestination(
            icon: Icon(Icons.school), label: Text('Courses')),
        NavigationRailDestination(
            icon: Icon(Icons.person), label: Text('Profile')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 840;

        if (!isWide) {
          return Scaffold(
            appBar: AppBar(
                title: Text('${pages[selectedIndex].title} (NavigationBar)')),
            body: pages[selectedIndex],
            bottomNavigationBar: buildNavigationBar(),
          );
        }

        return Scaffold(
          appBar: AppBar(
              title: Text('${pages[selectedIndex].title} (NavigationRail)')),
          body: Row(
            children: [
              buildNavigationRail(),
              const VerticalDivider(width: 1),
              Expanded(child: pages[selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}
