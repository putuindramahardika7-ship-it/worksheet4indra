import 'package:flutter/material.dart';
import '../identity.dart';
import '../widgets/feedback_form.dart';

class Stage14Page extends StatelessWidget {
  const Stage14Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 14 - Feedback')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$studentId - $studentName'),
            SizedBox(height: 16),
            FeedbackForm(),
          ],
        ),
      ),
    );
  }
}
