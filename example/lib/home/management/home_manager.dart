import 'package:example/domain/use_case/increment_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:management/management.dart';

import 'home_management.dart';

@injectable
class HomeManager extends Manager<HomeState, HomeEffect> {
  HomeManager(this.incrementUseCase) : super(const HomeState());

  final IncrementUseCase incrementUseCase;

  Future<void> increment() => incrementUseCase(state.counter).handle(
        onStart: () => emit(state.copyWith(loading: true)),
        onData: (data) {
          emit(state.copyWith(counter: data));
          if (state.counter % 5 == 0) {
            publish(HomeEffect.reminder(count: state.counter));
          }
        },
        onDone: () => emit(state.copyWith(loading: false)),
      );
}
