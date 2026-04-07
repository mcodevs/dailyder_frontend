import 'package:flutter/material.dart';

import '../../../../core/widget/app_card.dart';

class ImportSubmissionPanel extends StatefulWidget {
  const ImportSubmissionPanel({
    required this.isSaving,
    required this.onCancelPressed,
    required this.onImportPressed,
    super.key,
  });

  final bool isSaving;
  final VoidCallback onCancelPressed;
  final void Function(String rawText) onImportPressed;

  @override
  State<ImportSubmissionPanel> createState() => ImportSubmissionPanelState();
}

class ImportSubmissionPanelState extends State<ImportSubmissionPanel> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Matndan import', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const Text(
            'Project / Task / Subtask formatidagi matnni shu yerga qo‘ying.',
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            minLines: 10,
            maxLines: 16,
            decoration: const InputDecoration(
              hintText:
                  'Project: TV Rain\nTask: IOS bug fix\nSubtask: ipad bug',
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: widget.isSaving
                    ? null
                    : () => widget.onImportPressed(controller.text),
                child: Text(widget.isSaving ? 'Import...' : 'Import qilish'),
              ),
              OutlinedButton(
                onPressed: widget.isSaving ? null : widget.onCancelPressed,
                child: const Text('Bekor qilish'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
