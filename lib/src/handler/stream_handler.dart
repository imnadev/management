import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:management/management.dart';

extension StreamHandlerExtension<T, S, E> on Stream<T> {
  Future<void> handle({
    VoidCallback? onStart,
    void Function(Object e)? onError,
    void Function(T data)? onData,
    VoidCallback? onDone,
    Manager? cancelWhenClosed,
  }) async {
    onStart?.call();
    final subscription = listen(
      onData,
      onError: (e, stackTrace) {
        if (GetIt.instance.isRegistered<Logger>()) {
          GetIt.instance<Logger>().d(
            e.toString(),
            error: e,
            stackTrace: stackTrace,
          );
        }
        onError?.call(e);
      },
      onDone: onDone,
    );
    if (cancelWhenClosed != null) {
      await cancelWhenClosed.stateSubject.sink.done;
      subscription.cancel();
      onDone?.call();
    }
  }
}


