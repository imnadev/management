This package is a small and easy to use state management solution for Flutter.

## Pattern
This package is a small and easy to use state management solution for Flutter.

## Pattern
* There are four classes: `Managed`, `Manager`, `State` and `Effect`.
* `Managed` is extended by the widget. It overrides `listener` and `builder` functions.
* `listener` is responsible for handling `Effect`s, like showing a snackbar, navigating to the next screen, etc.
* `buidler` is responsible for building the widget based on `State`, which may contain an index of a counter, a loading state of a button, etc.
*  `Manager` is responsible for all the UI logic while emitting states and publishing effects.

## Prerequisites
This packaged is currently designed to work on a project with certain conditions:
* The project must use auto_route for navigation.
* The project must use get_it for dependency injection and the `AppRouter` should be registered as `StackRouter` during initialization of get_it.
* The project must use injectable to generate code for get_it.
* The project must use freezed.

## Getting started
1. To install the package, include the git repository in your pubspec.yaml:
     ```  
management:
   git: https://github.com/imnadev/management.git
 ```
2. To generate a managed page, run this command in your terminal and give it a name of `home`:
   `dart run management:generate lib/presentation/`


## Package Usage
`home_management.dart` contains `HomeState` and `HomeEffect`. `HomeState` holds the current state of the widget. `HomeEffect` is used to fire side effects to the widget like displaying a dialog or navigating to a different screen.
```
@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int counter,
    @Default(false) bool loading,
  }) = _HomeState;
}

@freezed
sealed class HomeEffect with _$HomeEffect {
  const factory HomeEffect.reminder({required int dozen}) = Reminder;
}
```

`home_manager.dart` is where state management logic resides. It may call `emit` with a copy of current `HomeState` or `publish` with a new instance of `HomeEffect`.

```
@injectable
class HomeManager extends Manager<HomeState, HomeEffect> {
  HomeManager() : super(const HomeState());

  void startWith(int count) {
    emit(state.copyWith(counter: count));
  }

  Future<void> increment() => Future.delayed(const Duration(seconds: 1))
      .then((_) => state.counter + 1)
      .handle(
        onStart: () => emit(state.copyWith(loading: true)),
        onData: (data) {
          emit(state.copyWith(counter: data));
          if (state.counter % 12 == 0) {
            publish(HomeEffect.reminder(dozen: state.counter ~/ 12));
          }
        },
        onDone: () => emit(state.copyWith(loading: false)),
      );
}
```
`home_page.dart` is where the `Managed` widget lies. It overrides the `builder` funciton which is called whenever the state changes. It may also override `init` which is called during `initState` and `listener` which is called when an effect is published.
```
class HomePage extends Managed<HomeManager, HomeState, HomeEffect> {
  const HomePage({super.key});

  @override
  void init(context, manager) {
    manager.startWith(10);
  }

  @override
  void listener(context, manager, effect) {
    switch (effect) {
      case Reminder():
        final message =
            'You have pushed the button ${effect.dozen} dozen times';
        final snackBar = SnackBar(content: Text(message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
    }
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
        onPressed: manager.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```
