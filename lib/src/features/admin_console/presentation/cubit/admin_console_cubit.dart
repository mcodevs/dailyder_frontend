import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/data/enums/status.dart';
import '../../domain/repository/admin_console_repository.dart';
import 'admin_console_state.dart';

class AdminConsoleCubit extends Cubit<AdminConsoleState> {
  AdminConsoleCubit({required this.repository})
    : super(const AdminConsoleState(status: Status.initial));

  final AdminConsoleRepository repository;

  Future<void> loadOverview() async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        infoMessage: null,
      ),
    );
    try {
      emit(
        state.copyWith(
          status: Status.success,
          overview: await repository.getOverview(),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(status: Status.error, errorMessage: error.toString()),
      );
    }
  }

  Future<void> loadPending() async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        infoMessage: null,
      ),
    );
    try {
      emit(
        state.copyWith(
          status: Status.success,
          pendingSnapshot: await repository.getPending(),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(status: Status.error, errorMessage: error.toString()),
      );
    }
  }

  Future<void> loadMetrics() async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        infoMessage: null,
      ),
    );
    try {
      emit(
        state.copyWith(
          status: Status.success,
          metricsSnapshot: await repository.getMetrics(),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(status: Status.error, errorMessage: error.toString()),
      );
    }
  }

  Future<void> loadUsers() async {
    emit(
      state.copyWith(
        status: Status.loading,
        errorMessage: null,
        infoMessage: null,
      ),
    );
    try {
      emit(
        state.copyWith(
          status: Status.success,
          users: await repository.getUsers(),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(status: Status.error, errorMessage: error.toString()),
      );
    }
  }

  Future<void> sendReminder(String period) async {
    emit(state.copyWith(isBusy: true, errorMessage: null, infoMessage: null));
    try {
      final sentCount = await repository.sendReminder(period);
      emit(
        state.copyWith(
          isBusy: false,
          infoMessage: '$period reminder yuborildi: $sentCount',
        ),
      );
    } on Object catch (error) {
      emit(state.copyWith(isBusy: false, errorMessage: error.toString()));
    }
  }

  Future<void> createWarning({
    required String developerUsername,
    required String reason,
  }) async {
    emit(state.copyWith(isBusy: true, errorMessage: null, infoMessage: null));
    try {
      emit(
        state.copyWith(
          isBusy: false,
          warningResult: await repository.createWarning(
            developerUsername: developerUsername,
            reason: reason,
          ),
          infoMessage: 'Warning yuborildi.',
        ),
      );
    } on Object catch (error) {
      emit(state.copyWith(isBusy: false, errorMessage: error.toString()));
    }
  }

  Future<void> createBindingIntent() async {
    emit(state.copyWith(isBusy: true, errorMessage: null, infoMessage: null));
    try {
      emit(
        state.copyWith(
          isBusy: false,
          bindingIntent: await repository.createGroupBindingIntent(),
          infoMessage: 'Binding token yaratildi.',
        ),
      );
    } on Object catch (error) {
      emit(state.copyWith(isBusy: false, errorMessage: error.toString()));
    }
  }
}
