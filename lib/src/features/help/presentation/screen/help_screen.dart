import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widget/app_card.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        HelpHeroCard(),
        SizedBox(height: 16),
        HelpStepCard(
          step: '01',
          title: 'Draftni yig‘ing',
          description:
              'Bugungi tasklar bo‘limida task va subtasklarni qo‘shing.',
        ),
        SizedBox(height: 12),
        HelpStepCard(
          step: '02',
          title: 'AM yuboring',
          description:
              'Ro‘yxat tayyor bo‘lgach bitta asosiy tugma bilan yuboring.',
        ),
        SizedBox(height: 12),
        HelpStepCard(
          step: '03',
          title: 'PM update kiriting',
          description:
              'Har bir task holatini belgilang va yakuniy izoh yozing.',
        ),
        SizedBox(height: 12),
        HelpStepCard(
          step: '04',
          title: 'Admin oqimi',
          description:
              'Admin panel pending, metrics, reminders va warnings uchun ishlatiladi.',
        ),
      ],
    );
  }
}

class HelpHeroCard extends StatelessWidget {
  const HelpHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Qisqa yo‘riqnoma',
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Dailyder oqimi sodda: draft yozing, yuboring, keyin statuslarni belgilang.',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            'Interfeys Telegram ichida tez ishlashi uchun ixcham, mobilga qulay va bir qo‘l bilan boshqarishga moslangan.',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class HelpStepCard extends StatelessWidget {
  const HelpStepCard({
    required this.step,
    required this.title,
    required this.description,
    super.key,
  });

  final String step;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.surfaceRaised,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
