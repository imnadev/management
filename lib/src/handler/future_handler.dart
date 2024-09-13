import 'dart:async';
import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

extension FutureHandlerExtension<T> on Future<T> {
  Future<void> handle({
    VoidCallback? onStart,
    void Function(Object e)? onError,
    void Function(T data)? onData,
    VoidCallback? onDone,
  }) async {
    onStart?.call();
    try {
      final data = await this;
      onData?.call(data);
    } catch (e, stackTrace) {
      if (GetIt.instance.isRegistered<Logger>()) {
        GetIt.instance<Logger>().d(
          e.toString(),
          error: e,
          stackTrace: stackTrace,
        );
      }
      onError?.call(e);
    } finally {
      onDone?.call();
    }
  }
}
