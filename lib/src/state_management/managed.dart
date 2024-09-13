import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:management/management.dart';
import 'package:provider/provider.dart';

abstract class Managed<MANAGER extends Manager<STATE, EFFECT>, STATE, EFFECT>
    extends StatefulWidget {
  const Managed({super.key});

  void init(BuildContext context, MANAGER manager) {}

  Widget builder(BuildContext context, MANAGER manager, STATE state);

  void listener(BuildContext context, MANAGER manager, EFFECT effect) {}

  @override
  State<Managed> createState() => ManagedState<MANAGER, STATE, EFFECT>();
}

class ManagedState<MANAGER extends Manager<STATE, EFFECT>, STATE, EFFECT>
    extends State<Managed> {
  late MANAGER _manager;

  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _manager = GetIt.instance<MANAGER>();
    widget.init(context, _manager);
    _subscription = _manager.effectSubject.listen((effect) {
      widget.listener(context, _manager, effect);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _manager.close();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<MANAGER>.value(
      value: _manager,
      child: StreamBuilder<STATE>(
        initialData: _manager.state,
        stream: _manager.stateSubject,
        builder: (context, snapshot) => widget.builder(
          context,
          _manager,
          snapshot.data,
        ),
      ),
    );
  }
}
