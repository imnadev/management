import 'manager.dart';

abstract class Observer {
  void onStateEmitted(Manager manager, dynamic current, dynamic next);
  void onEffectPublished(Manager manager, Object? effect);
}