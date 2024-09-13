import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

extension StreamHandlerExtension<T> on Stream<T> {
  Future<void> handle({
    VoidCallback? onStart,
    void Function(Object e)? onError,
    void Function(T data)? onData,
    VoidCallback? onDone,
  }) async {
    onStart?.call();
    try {
      await for (final data in this) {
        onData?.call(data);
      }
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
