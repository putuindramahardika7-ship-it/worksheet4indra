import 'package:flutter/material.dart';
import '../widgets/feedback_form.dart';
import '../widgets/identity_banner.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IdentityBanner(),
              const SizedBox(height: 24),
              Text('Form Feedback',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              const FeedbackForm(),
            ],
          ),
        ),
      ),
    );
  }
}
