This package is a small and easy to use state management solution for Flutter.

## Features

1. A helper plugin to generate the state classes, a state manager class and a state managed widget.
2. Separate streams for the widget's state and side effects.
3. Helper extensions to handle state when working with Future and Stream.

## Prerequisites
This package is designed to work with a project which uses auto_route, get_it, injectable, and freezed libraries.

## Getting started
1. To install the plugin:
   a. Android Studio -> Settings -> Plugins -> ⚙ -> Install Plugin from Disk
   b. Choose the plugin.jar file downloaded from this github repository.

2. To install the package, include the git repository in your pubspec.yaml:
```
  management:
      git: https://github.com/imnadev/management.git
```

## Plugin Usage
 1. Right click on where you would like to create your page.
 2. New -> Managed Page: Type the name of your page.
 3. It will create the page with all the necessary classes

## Package Usage
`home_management.dart` contains `HomeState` and `HomeEffect`. `HomeState` holds the current state of the widget. `HomeEffect` is used to fire side effects to the widget like displaying a dialog or navigating to a different screen.
```
@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(0) int counter,
    @Default(false) bool loading,
  }) = _HomeState;
}

@freezed
class HomeEffect with _$HomeEffect {
  const factory HomeEffect.reminder({required int dozen}) = _Reminder;
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
    effect.when(
      reminder: (dozed) {
        final snackBar = SnackBar(
          content: Text('You have pushed the button $dozed dozen times'),
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
```
