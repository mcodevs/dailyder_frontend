import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';

class AdminWarningFormSection extends StatefulWidget {
  const AdminWarningFormSection({
    required this.onSubmitPressed,
    required this.isBusy,
    super.key,
  });

  final void Function({
    required String developerUsername,
    required String reason,
  })
  onSubmitPressed;
  final bool isBusy;

  @override
  State<AdminWarningFormSection> createState() =>
      AdminWarningFormSectionState();
}

class AdminWarningFormSectionState extends State<AdminWarningFormSection> {
  late final TextEditingController usernameController;
  late final TextEditingController reasonController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    reasonController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Warning yuborish',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Developer username'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: reasonController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Sabab'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: widget.isBusy
                ? null
                : () {
                    widget.onSubmitPressed(
                      developerUsername: usernameController.text,
                      reason: reasonController.text,
                    );
                  },
            child: Text(widget.isBusy ? 'Yuborilmoqda...' : 'Warning yuborish'),
          ),
        ],
      ),
    );
  }
}
