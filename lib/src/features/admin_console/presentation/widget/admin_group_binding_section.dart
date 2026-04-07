import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';
import '../../domain/entity/admin_console_entities.dart';

class AdminGroupBindingSection extends StatelessWidget {
  const AdminGroupBindingSection({
    required this.onCreatePressed,
    required this.isBusy,
    super.key,
    this.bindingIntent,
  });

  final VoidCallback onCreatePressed;
  final bool isBusy;
  final GroupBindingIntentResult? bindingIntent;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Group binding', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const Text(
            'Token yarating va guruh ichida shu komandani yuboring. Bu Mini App yaratgan binding intentni Telegram orqali tasdiqlaydi.',
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: isBusy ? null : onCreatePressed,
            child: Text(isBusy ? 'Yaratilmoqda...' : 'Binding token yaratish'),
          ),
          if (bindingIntent != null) ...[
            const SizedBox(height: 16),
            SelectableText('Command: ${bindingIntent!.bindCommand}'),
            const SizedBox(height: 8),
            SelectableText('Expires: ${bindingIntent!.expiresAt}'),
          ],
        ],
      ),
    );
  }
}
