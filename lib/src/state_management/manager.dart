import 'package:rxdart/rxdart.dart';

import 'observer.dart';

abstract class Manager<STATE, EFFECT> {
  final BehaviorSubject<STATE> stateSubject;
  final effectSubject = PublishSubject<EFFECT>();

  STATE get state => stateSubject.value;

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
    stateSubject.close();
    effectSubject.close();
    isClosed = true;
  }

  void rebuild() => emit(state);
}
