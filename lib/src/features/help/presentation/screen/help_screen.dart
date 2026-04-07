import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Qanday ishlaydi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 12),
              Text('1. Bugungi tasklar bo‘limida draft yig‘ing.'),
              Text('2. Tasklarni ko‘rib chiqib AM yuboring.'),
              Text(
                '3. PM update bo‘limida har bir task va subtask holatini belgilang.',
              ),
              Text(
                '4. Admin panel orqali pending, metrics, reminders va warnings bilan ishlang.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
