import 'package:flutter/material.dart';

class DevLoginForm extends StatefulWidget {
  const DevLoginForm({
    required this.onSubmit,
    required this.isLoading,
    super.key,
  });

  final void Function({
    required String username,
    required String telegramUserId,
  })
  onSubmit;
  final bool isLoading;

  @override
  State<DevLoginForm> createState() => DevLoginFormState();
}

class DevLoginFormState extends State<DevLoginForm> {
  late final TextEditingController usernameController;
  late final TextEditingController telegramUserIdController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    telegramUserIdController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    telegramUserIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            hintText: '@devuser',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: telegramUserIdController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Telegram user ID'),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    widget.onSubmit(
                      username: usernameController.text,
                      telegramUserId: telegramUserIdController.text,
                    );
                  },
            child: Text(widget.isLoading ? 'Kutilmoqda...' : 'Dev login'),
          ),
        ),
      ],
    );
  }
}
