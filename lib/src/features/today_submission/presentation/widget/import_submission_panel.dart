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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Matndan import',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Project / Task / Subtask formatidagi matnni shu yerga qo‘ying.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  'Import',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            minLines: 10,
            maxLines: 16,
            decoration: const InputDecoration(
              hintText:
                  'Project: TV Rain\nTask: IOS bug fix\nSubtask: ipad bug',
              prefixIcon: Icon(Icons.text_snippet_outlined),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.isSaving
                  ? null
                  : () => widget.onImportPressed(controller.text),
              icon: widget.isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file_rounded),
              label: Text(widget.isSaving ? 'Import...' : 'Import qilish'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.isSaving ? null : widget.onCancelPressed,
              icon: const Icon(Icons.close_rounded),
              label: const Text('Bekor qilish'),
            ),
          ),
        ],
      ),
    );
  }
}
