import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_management.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int counter,
    @Default(false) bool loading,
  }) = _HomeState;
}

@freezed
class HomeEffect with _$HomeEffect {
  const factory HomeEffect.reminder({required int count}) = _Reminder;
}
