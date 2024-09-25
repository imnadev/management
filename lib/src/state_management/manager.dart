import 'package:rxdart/rxdart.dart';

abstract class Manager<STATE, EFFECT> {
  final BehaviorSubject<STATE> stateSubject;
  final effectSubject = PublishSubject<EFFECT>();

  STATE get state => stateSubject.value;

  bool isClosed = false;

  Manager(STATE initialState)
      : stateSubject = BehaviorSubject<STATE>.seeded(initialState);

  void emit(STATE state) {
    if (stateSubject.isClosed) return;
    stateSubject.add(state);
  }

  void publish(EFFECT effect) {
    if (effectSubject.isClosed) return;
    this.effectSubject.add(effect);
  }

  Future<void> close() async {
    stateSubject.close();
    effectSubject.close();
    isClosed = true;
  }
}
