import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/data/enums/status.dart';
import '../../../../core/widget/app_card.dart';
import '../../../../core/widget/app_status_view.dart';
import '../cubit/session_cubit.dart';
import '../cubit/session_state.dart';
import '../widget/dev_login_form.dart';

class SessionGateScreen extends StatelessWidget {
  const SessionGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          if (state.status.isInitial || state.status.isLoading) {
            return const AppStatusView(
              title: 'Dailyder Mini App',
              message: 'Sessiya tekshirilmoqda...',
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dailyder Mini App',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.telegramEnvironment
                          ? 'Telegram Mini App muhiti aniqlandi. Sessiyani yangilash uchun sahifani qayta oching.'
                          : 'Telegram tashqarisida ishlayapsiz. Dev login orqali API bilan ishlashingiz mumkin.',
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        state.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    if (state.devAuthEnabled) ...[
                      const SizedBox(height: 24),
                      DevLoginForm(
                        isLoading: state.status == Status.loading,
                        onSubmit:
                            ({
                              required String username,
                              required String telegramUserId,
                            }) {
                              context.read<SessionCubit>().signInWithDevInput(
                                username: username,
                                telegramUserIdText: telegramUserId,
                              );
                            },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
