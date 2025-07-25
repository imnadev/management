import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'binder.dart';
import 'observer.dart';

abstract class Manager<STATE, EFFECT> {
  final BehaviorSubject<STATE> stateSubject;
  final effectSubject = PublishSubject<EFFECT>();

  STATE get state => stateSubject.value;

  final binder = Binder();

  bool isClosed = false;

  static Observer? observer;

  Manager(STATE initialState)
      : stateSubject = BehaviorSubject<STATE>.seeded(initialState);

  void emit(STATE state) {
    if (stateSubject.isClosed) return;
    if (state != stateSubject.value) {
      observer?.onStateEmitted(this, stateSubject.value, state);
    }
    stateSubject.add(state);
  }

  void publish(EFFECT effect) {
    if (effectSubject.isClosed) return;
    observer?.onEffectPublished(this, effect);
    this.effectSubject.add(effect);
  }

  Future<void> close() async {
    await binder.close();
    stateSubject.close();
    effectSubject.close();
    isClosed = true;
  }

  void rebuild() => emit(state);

  void initialize() {}

  Binding bind<T extends Object?>(Stream<T> Function() streamFactory,
      void Function(T data) onData,) => binder.bind(streamFactory, onData);
}
