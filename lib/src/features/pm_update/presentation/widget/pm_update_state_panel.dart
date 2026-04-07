import 'package:flutter/material.dart';

import 'pm_update_theme.dart';

class PmUpdateStatePanel extends StatelessWidget {
  const PmUpdateStatePanel({
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onActionPressed,
    this.isLoading = false,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: PmUpdateTheme.panelDecoration(elevated: true),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: PmUpdateTheme.surfaceSoft,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: PmUpdateTheme.border),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            PmUpdateTheme.accent,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.insights_outlined,
                        color: PmUpdateTheme.accent,
                      ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: PmUpdateTheme.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: PmUpdateTheme.textSecondary,
                height: 1.45,
              ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onActionPressed,
                  style: PmUpdateTheme.primaryButtonStyle(),
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
