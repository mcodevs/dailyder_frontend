import 'package:flutter/material.dart';

import '../../common/extensions/build_context_extensions.dart';

class AppStatusView extends StatelessWidget {
  const AppStatusView({
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: context.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: context.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
