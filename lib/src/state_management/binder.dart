import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class Binding<T> {
  final Stream<T> Function() streamFactory;
  final void Function(T) onData;

  T? last;
  bool loaded = false;
  dynamic error;

  StreamSubscription<T>? subscription;

  Future<void> cancel() async => await subscription?.cancel();

  Binding(this.streamFactory, this.onData);

  Future<void> run([void Function()? onChanged]) async {
    await subscription?.cancel();
    error = null;
    subscription = streamFactory().listen(
      (data) {
        last = data;
        loaded = true;
        error = null;
        onData(data);
        onChanged?.call();
      },
      onError: (e, stackTrace) {
        error = e;
        onChanged?.call();
        if (GetIt.instance.isRegistered<Logger>()) {
          GetIt.instance<Logger>().d(
            e.toString(),
            error: e,
            stackTrace: stackTrace,
          );
        }
      },
    );
  }
}

class Binder {
  final bindings = <Binding>[];

  void Function(bool loading)? onLoading;
  void Function(bool loading)? onError;

  Binding bind<T extends Object?>(
    Stream<T> Function() streamFactory,
    void Function(T data) onData,
  ) {
    final binding = Binding<T>(streamFactory, onData);
    bindings.add(binding);
    return binding;
  }

  Future<void> run() async {
    void onChanged() {
      final anyLoading = bindings.any((e) => !e.loaded);
      final noError = bindings.every((e) => e.error == null);
      final anyError = bindings.any((e) => !e.loaded && e.error != null);

      onLoading?.call(anyLoading && noError);
      onError?.call(anyError);
    }

    await Future.wait(bindings.map((b) => b.run(onChanged)));
    onChanged();
  }

  Future<void> close() =>
      Future.wait(bindings.map((e) => e.cancel()).nonNulls);
}
