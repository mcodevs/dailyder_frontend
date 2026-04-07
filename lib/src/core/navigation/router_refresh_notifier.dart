import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../features/session/presentation/cubit/session_cubit.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier({required SessionCubit sessionCubit}) {
    subscription = sessionCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> subscription;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
