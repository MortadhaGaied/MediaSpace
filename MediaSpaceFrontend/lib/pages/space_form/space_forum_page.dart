import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProgressPage(),
    );
  }
}

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Progress Bar Example')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemCount: 15,
              itemBuilder: (context, index) {
                return Center(child: Text('Page ${index + 1}'));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (currentPage > 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text('Previous'),
                ),
                CustomProgressBar(currentPage: currentPage),
                ElevatedButton(
                  onPressed: () {
                    if (currentPage < 14) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  final int currentPage;

  CustomProgressBar({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    int section = (currentPage / 5).floor();
    double progressWithinSection = (currentPage % 5) / 5.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildSection(0, section, progressWithinSection),
        buildSection(1, section, progressWithinSection),
        buildSection(2, section, progressWithinSection),
      ],
    );
  }

  Widget buildSection(int sectionIndex, int currentSection, double progress) {
    Color color;
    if (sectionIndex < currentSection) {
      color = Colors.green;
    } else if (sectionIndex > currentSection) {
      color = Colors.grey;
    } else {
      color = Color.lerp(
        Colors.grey,
        Colors.green,
        progress,
      )!;
    }
    return Expanded(
      child: Container(
        height: 10,
        color: color,
      ),
    );
  }
}
