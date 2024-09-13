import 'package:rxdart/rxdart.dart';

abstract class Manager<STATE, EFFECT> {
  final BehaviorSubject<STATE> stateSubject;
  final effectSubject = PublishSubject<EFFECT>();

  STATE get state => stateSubject.value;

  Manager(STATE initialState)
      : stateSubject = BehaviorSubject<STATE>.seeded(initialState);

  void emit(STATE state) {
    stateSubject.add(state);
  }

  void publish(EFFECT effect) {
    this.effectSubject.add(effect);
  }

  Future<void> close() async {
    stateSubject.close();
    effectSubject.close();
  }
}
