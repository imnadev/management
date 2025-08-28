import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:get_it/get_it.dart';
import 'package:management/management.dart';
import 'package:provider/provider.dart';

abstract class Managed<MANAGER extends Manager<STATE, EFFECT>, STATE, EFFECT>
    extends StatefulWidget {
  const Managed({super.key});

  void init(BuildContext context, MANAGER manager) {}

  Widget builder(BuildContext context, MANAGER manager, STATE state);

  void listener(BuildContext context, MANAGER manager, EFFECT effect) {}

  void onNavigateBack(MANAGER manager) {}

  void onFocusGained(BuildContext context, MANAGER manager) {}

  void onFocusLost(BuildContext context, MANAGER manager) {}

  void dispose() {}

  void didUpdateWidget(MANAGER manager, Managed oldWidget) {}

  @override
  State<Managed> createState() => ManagedState<MANAGER, STATE, EFFECT>();
}

class ManagedState<MANAGER extends Manager<STATE, EFFECT>, STATE, EFFECT>
    extends State<Managed> with AutoRouteAware {
  late MANAGER _manager;

  late StreamSubscription _subscription;

  AutoRouteObserver? _observer;

  @override
  void initState() {
    super.initState();
    _manager = GetIt.instance<MANAGER>();
    widget.init(context, _manager);
    _subscription = _manager.effectSubject.listen((effect) {
      widget.listener(context, _manager, effect);
    });

    _manager.initialize();
    _manager.binder.run();
  }

  @override
  void dispose() {
    super.dispose();
    _manager.close();
    _subscription.cancel();
    widget.dispose();
    _observer?.unsubscribe(this);
  }

  @override
  void didUpdateWidget(Managed oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget(_manager, oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observer =
        RouterScope.of(context).firstObserverOfType<AutoRouteObserver>();
    if (_observer != null) {
      _observer!.subscribe(this, context.routeData);
    }
  }

  @override
  void didPopNext() => widget.onNavigateBack(_manager);

  @override
  Widget build(BuildContext context) {
    bool lost = false;
    return FocusDetector(
      onFocusGained: () {
        if (!lost) return;
        widget.onFocusGained(context, _manager);
      },
      onFocusLost: () {
        lost = true;
        widget.onFocusLost(context, _manager);
      },
      child: Provider<MANAGER>.value(
        value: _manager,
        child: StreamBuilder<STATE>(
          initialData: _manager.state,
          stream: _manager.stateSubject,
          builder: (context, snapshot) =>
              widget.builder(context, _manager, snapshot.data),
        ),
      ),
    );
  }
}
