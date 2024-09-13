import 'package:flutter/material.dart';
import 'package:management/management.dart';

import 'management/home_management.dart';
import 'management/home_manager.dart';

class HomePage extends Managed<HomeManager, HomeState, HomeEffect> {
  const HomePage({super.key});

  @override
  void init(context, manager) {}

  @override
  void listener(context, manager, effect) {
    effect.when(
      reminder: (count) {
        final snackBar = SnackBar(
          content: Text('You have pushed the button $count times'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }

  @override
  Widget builder(context, manager, state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              state.counter.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          manager.increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
