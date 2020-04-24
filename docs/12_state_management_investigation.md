# State management investigation

> Summary of the proposed change

Document the criteria for selecting the best state management approach for the metrics web app.

# References

> Link to supporting documentation, GitHub tickets, etc.

- [Bloc pattern](http://flutterdevs.com/blog/bloc-pattern-in-flutter-part-1/)
- [Bloc library](https://www.netguru.com/codestories/flutter-bloc)
- [Redux](https://pub.dev/packages/flutter_redux)
- [Provider](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)
- [Provider package](https://pub.dev/packages/provider)
- [States rebuilder](https://github.com/GIfatahTH/states_rebuilder)
- [State notifier](https://pub.dev/packages/flutter_state_notifier)
- [State management explained](https://resocoder.com/2020/04/09/flutter-state-management-tutorial-provider-changenotifier-bloc-mobx-more/)

# Motivation

> What problem is this project solving?

Simplify the development process of the metrics web app.

# Design

> Explain and diagram the technical design

`UI` -> `State management` -> `Application State` -> `UI`

# Alternatives Considered

> Summarize alternative designs (pros & cons)

## Summary table

|                                   | Bloc | States rebuilder | Bloc library | Redux | Provider | State notifier |
| --------------------------------- | ---- | ---------------- | ------------ | ----- | -------- | -------------- |
| Asynchronous                      | 3    | 5                | 5            | 3     | 5        | 5              |
| Reactivity                        | 5    | 2                | 2            | 3     | 4        | 4              |
| Boilerplate absence               | 5    | 4                | 1            | 1     | 5        | 4              |
| Maintainability                   | 4    | 4                | 3            | 3     | 4        | 4              |
| State snapshot                    | 1    | 2                | 5            | 5     | 2        | 2              |
| Debugging                         | 4    | 3                | 4            | 4     | 3        | 3              |
| Undo/Redo actions                 | 0    | 0                | 1            | 5     | 0        | 0              |
| Testability                       | 4    | 5                | 4            | 4     | 5        | 5              |
| Easy to learn / Namings           | 1    | 4                | 1            | 1     | 5        | 5              |
| State mutability / Immutability   | -    | -                | -            | -     | -        | -              |
| Flutter integration / Reusability | -    | -                | -            | -     | -        | -              |
| Analytics/Centralized             | -    | -                | -            | -     | -        | -              |

# Navigation

1. [BLoC pattern](#BLoC-pattern)
   - [Asynchronous](#Asynchronous)
   - [Reactivity](#Reactivity)
   - [Boilerplate](#Boilerplate)
   - [Maintainability](#Maintainability)
   - [State snapshot](#State-snapshot)
   - [Debugging](#Debugging)
   - [Undo/Redo actions](#Undo/Redo-actions)
   - [Testability](#Testability)
   - [Easy to learn](#Easy-to-learn)
   - State Mutability / Immutability
   - Flutter integration / Reusability
   - Analytics/Centralized
2. [States Rebuilder](#States-Rebuilder)
   - [Asynchronous](#Asynchronous-1)
   - [Reactivity](#Reactivity-1)
   - [Boilerplate](#Boilerplate-1)
   - [Maintainability](#Maintainability-1)
   - [State snapshot](#State-snapshot-1)
   - [Debugging](#Debugging-1)
   - [Undo/Redo actions](#Undo/Redo-actions-1)
   - [Testability](#Testability-1)
   - [Easy to learn](#Easy-to-learn-1)
   - State Mutability / Immutability
   - Flutter integration / Reusability
   - Analytics/Centralized
3. [BLoC library](#BLoC-library)
   - [Asynchronous](#Asynchronous-2)
   - [Reactivity](#Reactivity-2)
   - [Boilerplate](#Boilerplate-2)
   - [Maintainability](#Maintainability-2)
   - [State snapshot](#State-snapshot-2)
   - [Debugging](#Debugging-2)
   - [Undo/Redo actions](#Undo/Redo-actions-2)
   - [Testability](#Testability-2)
   - [Easy to learn](#Easy-to-learn-2)
   - State Mutability / Immutability
   - Flutter integration / Reusability
   - Analytics/Centralized
4. [Redux](#Redux)
   - [Asynchronous](#Asynchronous-3)
   - [Reactivity](#Reactivity-3)
   - [Boilerplate](#Boilerplate-3)
   - [Maintainability](#Maintainability-3)
   - [State snapshot](#State-snapshot-3)
   - [Debugging](#Debugging-3)
   - [Undo/Redo actions](#Undo/Redo-actions-3)
   - [Testability](#Testability-3)
   - [Easy to learn/Namings](#Easy-to-learn/Namings-3)
   - [State Mutability/Immutability](#State-Mutability/Immutability-3)
   - [Flutter integration/Reusability](#Flutter-integration/Reusability-3)
   - Analytics/Centralized
5. [Provider](#Provider)
   - [Asynchronous](#Asynchronous-4)
   - [Reactivity](#Reactivity-4)
   - [Boilerplate](#Boilerplate-4)
   - [Maintainability](#Maintainability-4)
   - [State snapshot](#State-snapshot-4)
   - [Debugging](#Debugging-4)
   - [Undo/Redo actions](#Undo/Redo-actions-4)
   - [Testability](#Testability-4)
   - [Easy to learn/Namings](#Easy-to-learn/Namings-4)
   - State Mutability / Immutability
   - Flutter integration / Reusability
   - Analytics/Centralized
6. [State notifier](#State-notifier)
   - [Asynchronous](#Asynchronous-5)
   - [Reactivity](#Reactivity-5)
   - [Boilerplate](#Boilerplate-5)
   - [Maintainability](#Maintainability-5)
   - [State snapshot](#State-snapshot-5)
   - [Debugging](#Debugging-5)
   - [Undo/Redo actions](#Undo/Redo-actions-5)
   - [Testability](#Testability-5)
   - [Easy to learn](#Easy-to-learn-5)
   - State Mutability / Immutability
   - Flutter integration / Reusability
   - Analytics/Centralized

## [BLoC pattern](http://flutterdevs.com/blog/bloc-pattern-in-flutter-part-1/)

The BLoC is an architectural pattern that functions as a state management solution. All business logic is extracted from the UI into BLoC (Business Logic Components). The UI should only publish events to the BLoCs and display the UI based on the state of the BLoCs.

//todo: main idea: Bloc contains only streams, data pushed to bloc only using Sinks, Output data as streams, Works tightly with RxDArt

### Code sample

Assume we have an `AuthBloc` that provides an ability to sign in a user and holds the current authentication state.

```dart
class AuthBloc {
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  final StreamController<AuthCredentials> _signInController =
      StreamController();

  Stream<bool> get isLoggedInStream => _isLoggedInSubject.stream;

  Sink<AuthCredentials> get signInSink => _signInController.sink;

  AuthBloc() {
    _signInController.stream.listen(_signInListener);
  }

  void _signInListener(AuthCredentials event) {
    // sign in logic
    _isLoggedInSubject.add(true);
  }
}
```

So, to subscribe to the auth updates, we should subscribe to `isLoggedInStream`, whether using the regular listener function `isLoggedInStream.listen(...)` or using the `StreamBuilder` to update the UI based on the current stream value. If we want to sign in a user, we have a `Sink`, so we should call `signInSink.add(credentials)` to trigger the sign in process.

Because we have only streams as the output of the BLoC, we can easily build the reactive granular UI, using the `StreamBuilder` widget and dividing the UI to the logical parts that will be controlled by a separate stream in BLoC.

### Conclusion

#### Asynchronous

To prepare an async operation in BLoC and obtain its result, we should create a `StreamController` that will trigger the async operation and the `BehaviorSubject` that will provide the result of this operation or an error that occurred during loading.

```dart
class ProjectsBloc {
  final StreamController<bool> _loadProjectsController = StreamController();

  Sink<bool> get loadProjectsSink => _loadProjectsController.sink;

  final BehaviorSubject<List<Project>> _projectsSubject = BehaviorSubject();

  Stream<List<Project>> get projectsStream => _projectsSubject.stream;

  ProjectsBloc() {
    _loadProjectsController.stream.listen(_loadProjects);
  }

  void _loadProjects(bool event) async {
    try {
      /// loading projects asynchronously.
      ....
      final loadedProject = await repository.getProjects();
      ///
      _projectsSubject.add(loadedProjects);
    } catch (exception){
      _projectsSubject.addError(LoadingError(message: 'error message'));
    }
  }
}
```

So, to load the projects using some API, for example, we should call the `projectsBloc.loadProjectsSink.add(true)` method. After loading finished or an error occurred, we will receive our projects to the `projectsBloc.projectsStream` stream:

```dart

```

#### Reactivity

To update the UI corresponding to stream value, we just should create the stream in BLoC and use the `StreamBuilder` widget that will listen to stream updates and provide it's snapshots to the `builder` function. Let's consider the concrete example with the `projectsStream`:

Assume we have some page that should display the list of all projects.

```dart
return Scaffold(
  body: StreamBuilder(
    stream: _projectsBloc.projectsStream,
    builder: (context, snapshot) {
      if (!snapshot.hasData) return CircularProgressIndicator();

      return ListView(
        children: _buildProjectWidgets(snapshot.data),
      );
    },
  ),
);
```

#### Boilerplate

To create a new BLoC, you just should create the class that will contain business logic. The only place of the boilerplate code is the creation of the Streams and Sinks. The example of the simple BLoC is presented above in [Reactivity](#Reactivity) or [Code sample](#Code_sample) sections.

#### New feature boilerplate absence

To add the new feature to the existing BLoC, it is needed to create a separate `Stream`, that will contain the new value to display, and the `Sink` that will be used to trigger related business logic from UI or another BLoC if needed.

#### Maintainability

The applications that use the BLoC pattern as the state management are highly maintainable because all of the business logic is separated from the UI. Moreover, the business processes could be triggered only from one place - the sink, and it helps to find errors, bugs, etc. in the code. Also, because of the low level of the boilerplate code and good separation of the features, it is easy to add a new feature by adding a new BLoC or change the behavior of the existing feature by modifying the logic in the existing BLoC.

#### State snapshot

There is no ability to make the application state snapshot because the application state is divided into separate BLoCs, but we can make a snapshot of the current BLoC, by subscribing to the streams.

//todo no easy way

#### Debugging

The BLoC pattern is well-debuggable because the only way to trigger an event is to add something to the stream. But the debug process is not perfect, because you can't, for example, print the whole application state, you can only print the events, coming to some stream.

//todo: hard to find place where it's called

#### Undo/Redo actions

The BLoC pattern has no embedded support of the undo/redo feature.

#### Testability

The BLoC pattern is pretty good testable because it is based on the streams, and the dart [testing framework](https://pub.dev/packages/test) has a [StreamMatcher](https://pub.dev/documentation/test_api/latest/test_api/StreamMatcher-class.html) class that helps to write the tests for stream-based functionality.

#### Easy to learn

The BLoC pattern could be pretty hard to understand if you are not familiar with the [rxdart](https://pub.dev/packages/rxdart) or at least dart streams.

Score: \* + description why?

#### Pros

1. Has clear architectural rules. It implies using the stream for communication between UI and BLoC and two separate blocks. In simple words - nothing except streams and sinks available from outside of the BLoC.
2. Easy to test and debug the business logic.
3. The widget tree could be rebuilt granular only when the data for the exact subtree is changed.
4. Easy to subscribe to the application state updates outside of the UI.
5. Has the great support of [reactivity](#Reactivity).
6. Has low level of the [boilerplate code](#Initial_boilerplate_absence).
7. Has high level of [maintainability](#Maintainability).
8. Pretty good [testability](#Testability).

#### Cons

1. Relatively large entry [threshold](#Easy_to_learn).
2. Has an overhead because you should create a separate stream for API response results, etc.
3. Has not the best support of the [asynchronous programming](#Asynchronous).
4. No ability to make a [state snapshot](#State_snapshot).

## [States Rebuilder](https://github.com/GIfatahTH/states_rebuilder)

States Rebuilder if the package for flutter built on the observer pattern for state management and the service locator pattern for dependency injection. It is very similar to the Provider package but has a couple of additional features that make building the UI a bit easier.

### Code sample

Assume we have the `AuthStore` that should provide the same functionality as the `AuthBloc`.

```dart
class AuthStore {
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  Stream<bool> get loggedInStream => _isLoggedInSubject.stream;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    /// sign in logic
    _isLoggedInSubject.add(true);
  }
}
```

In case we want to subscribe to the application state updates we should:

1. Implement the `ObserverOfStatesRebuilder`.
2. Implement the `update` method to react to `AuthStore` updates.

The code sample of the application state subscription is shown below:

```dart
class _LoginPageState extends State<LoginPage> implements ObserverOfStatesRebuilder  {

  @override
  void initState() {
    Injector.get<AuthStore>().addObserver(observer: this);
    super.initState();
  }

  @override
  bool update([Function(BuildContext) onSetState, message]) {
      ...
  }
```

### Conclusion

#### Asynchronous

The States Rebuilder provides great support for asynchronous programming. To perform an async operation we need:

1. Get the injected reactive model, using the `Injector.getAsReactive()` method.
2. Call the `setState` method and pass the async function as the param:

```dart
Injector.getAsReactive<AuthStore>().setState((state) => state.signInWithEmailAndPassword(credentials))
```

While the future, returned from `signInWithEmailAndPassword` method, is not completed, the `AuthStore` reactive model will be in `waiting`. That means that the `onWaiting` builder of the `model.whenConnectionState` method will be used that helps to build the UI that will work with the asynchronous events and functions.

#### Reactivity

The States Rebuilder supports the reactive approach. It allows injecting the streams, using the `Inject.stream()` method.

For example, to subscribe to the authentication updates in the UI we should:

1. Inject the `loggedInStream` stream.

```dart
Injector(
    inject: [
        Inject<AuthStore>(() => AuthStore()),
        Inject.stream(() => Injector.get<AuthStore>().loggedInStream),
    ],
    builder: (BuildContext context) => widget.child,
);
```

2.  Create a StateRebuilder widget and build the UI accordingly to the model state.

```dart
StateBuilder(
  models: [Injector.getAsReactive<bool>()],
  builder: (_, model){
      return model.whenConnectionState(...);
  },
);
```

In case we want to subscribe to the authentication state stream updates outside of the UI, we should implement the `ObserverOfStatesRebuilder` interface, as shown in the [Code sample](#Code_sample-1) section.

#### Initial boilerplate absence

To create a new Store(the class that will contain the application business logic), we should create a class for this store, and inject it, using the `Injector` widget. Also, we should inject the streams which you want to use to build your UI if there is any.

#### New feature boilerplate absence

To add a stream that will be used to build the UI, we need to add the stream into the `Store` and inject it to be able to get it as reactive and use it in the `StateBuilder` widget.

#### Maintainability

The application that uses the States Rebuilder state management is pretty well maintainable because the business logic is separated from the UI. Also, it is pretty easy to add a new functionality because of the low level of boilerplate code. Surely, it is easy to change the existing functionality because it has a pretty understandable structure and data flow. But the problem of States Rebuilder is that the `store.setState()` should be called to rebuild the UI. Also, it has a complex mechanism of subscribing to state updates that could improve the complexity of maintainability.

#### State snapshot

Using the State Rebuilder, we cannot make a state snapshot because it has no common application state, but we can get a current snapshot of each separate reactive model at any time.

#### Debugging

The States Rebuilder is well-debuggable because the business logic is separated from the UI. Also, we can obtain a snapshot of the reactive model at any time that will help to catch errors and bugs. The only problem of debugging is that the UI could be updated in any place, by calling the `setState` method on the reactive model.

#### Undo/Redo actions

There is no embedded support of undo/redo.

#### Testability

The states of the States Rebuilder are nicely-testable because we can just separately test the methods of the state using the available public API.

#### Easy to learn

Since the States Rebuilder is very similar to the Provider and has a pretty simple mechanism of interaction between UI and business logic - method calls, it is pretty easy to learn.

### Pros

1. It provides useful callbacks `onError`, `onWaiting`, etc. to build the UI.
2. Has embedded dependency injection.
3. Relatively [simple for beginners](#Easy_to_learn-1).
4. Great support of [asynchronous programming](#Asynchronous-1).
5. Has a low level of [boilerplate code](#Initial_boilerplate_absence-1).
6. [Well testable](#Testability-1).

### Cons

1. Not bad support of [reactivity](#Reactivity-1).
2. Has a complex mechanism of subscription to the application state updates outside of .
3. The [debugging](#Debugging-1) of the UI changes could be pretty difficult.
4. Has a big [overhead](#New_feature_boilerplate_absence-1) in injecting each stream for UI.
5. Has lower level of [maintainability](#Maintainability-1) because of UI update mechanism.

## [BLoC library](https://pub.dev/packages/bloc)

The Bloc library is the package, used for managing the application state, which is based on the Redux concept.

### Code sample

Still the same `AuthBloc`, but now we should create a separate class for out authentication state, let's call it `AuthState`:

```dart
class AuthState {
  final bool isLoggedIn;


  AuthState copyWith({bool isLoggedIn}) {
    ...
  }
  ...
}
```

Also, we should create the `AuthEvent` abstract class - the base class for all events that used to interact with our `AuthBloc` and mutate the `AuthState`:

```dart
abstract class AuthEvent {}
```

Finally, we can create our `AuthBloc`:

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => AuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    ...
  }
}
```

Extending the `Bloc` class, we should implement two methods:

- the `initialState` getter that should return the initial state of our `AuthStore`
- the `mapEventToState` method that will receive the dispatched `AuthEvent`s and should yield a new `AuthState` on each event.

To add the functionality to our `AuthBloc`, we should:

1. Add a new event called `SignInAuthEvent`

   ```dart
   abstract class AuthEvent {}

   class SignInAuthEvent implements AuthEvent {
     final String email;
     final String password;

     ...
   }
   ```

2. Add implementation of the sign in to the `mapEventToState` method:

   ```dart
   @override
     Stream<AuthState> mapEventToState(AuthEvent event) async* {
       if (event is SignInAuthEvent) {
         await _signInUser(event.email, event.password);
         yield state.copyWith(isLoggedIn: true);
       }
     }

     Future<void> _signInUser(String email, String password) async {
       ...
     }
   ```

In the end, we have an `AuthBloc` that will contain a business logic and the `AuthStore` that will hold the application state.
Now we should inject our bloc to make it available on the UI. To do this, we should use the `BlocProvider` widget:

```dart
BlocProvider(
  create: (BuildContext context) => AuthBloc(),
  child: ...,
);
```

Now the `AuthBloc` is available for all down-laying widgets, so we can use the `BlocBuilder` or the `BlocConsumer` widgets to build your UI in respect of the current application state.

```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    // return widget here based on AuthBloc's state
  }
)
```

To start the sign in process it is needed to call the `BlocProvider.of<AuthBloc>(context).add(SignInAuthEvent(...))` method.

Then assume we have some `repository` that provides the `authUpdatesStream`. To subscribe to these updates and update the UI in response to data from this stream:

1. We should add `AuthStateUpdateEvent` and `SubscribeToAuthUpdatesEvent` events, as described above.
2. Then we should subscribe to `authUpdatesStream` in `AuthBloc` on `SubscribeToAuthUpdatesEvent` event and emit a new event each time the `authUpdatesStream` emits a new item:

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  StreamSubscription _authUpdatesSubscription;

  AuthBloc(this._repository);

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SubscribeToAuthUpdatesEvent) {
      _authUpdatesSubscription?.cancel();
      _authUpdatesSubscription = _repository
          .authUpdatesStream()
          .listen((authState) => add(AuthStateUpdateEvent()));
    }else if (event is AuthStateUpdateEvent) {
      /// update the state to change the UI.
    }
  }
  ...
}
```

### Conclusion

#### Asynchronous

The BLoC library has great support of asynchronous programming because you can just use the standard dart approach to wait for something asynchronous - the `await` keyword right inside of the `mapEventToState` method.

#### Reactivity

The BLoC library has not so good support of the reactivity because to update the UI corresponding to stream events you should add a lot of boilerplate code:

1. The first thing you should do is create three events:

   - An event that will trigger the subscription.
   - An event that will notify the BLoC about the new event in the stream.
   - An event that needed to cancel the created subscription.

2. The next step will be to add an implementation for these events to the `mapEventToState` method.

#### Initial boilerplate absence

There are a lot of initial boilerplate to create your first BLoC. As you can see in the [code sample](#Code_sample-2) section, you should create a state, actions, and the BLoC itself to start working on a project with this package.

#### New feature boilerplate absence

There is pretty much boilerplate code even to add a new feature or change the existing one. If you are trying to add a new feature to the existing BLoC, you should add an event, modify the state if needed, and implement the logic in the BLoC.

#### Maintainability

On the one hand, the BLoC library has a high level of maintainability because the state and the business logic are separated from UI. Also, it is very debuggable because all events come to one place - the `mapEventToState` method. On the other hand, the BLoC library has a lot of boilerplate code and overhead that will complicate the maintenance process. For example, to add a new feature to the existing BLoC, we should change the state (if required), create at least one event (more events for streams), add implementation to the `mapEventToState` method.

#### State snapshot

Using the BLoC library, it is easy to get the state snapshot because the state of the application is separated from UI and business logic.

#### Debugging

The BLoC library is highly debuggable, because it has the only one place all events come and the state changes - the `mapEventToState` method, and that is why it is very easy to track the state changes.

#### Undo/Redo actions

The BLoC library has no embedded implementation of the undo/redo actions, but it could be easily implemented because of the separated application state from the business logic.

#### Testability

There is a [bloc test](https://pub.dev/packages/bloc_test) package, created for testing the BLoC library's blocks.

#### Easy to learn

It could be not so easy to learn the BLoC library, especially if you are not familiar with redux and its approach to state management.

#### Pros

1. Nicely divided business logic from the application state.
2. Understandable data flow: `UI` -> `Action` -> `Bloc` -> `New State` -> `UI`
3. Embedded dependency injection mechanism.
4. Nice support of [asynchronous programming](#Asynchronous-2).
5. [Well-testable](#Testability-2).
6. Has a clear mechanism of changing the state, so could be [easily debugged](#Debugging-2).
7. It is easy to make a [state snapshot](#State_snapshot-2).

#### Cons

1. Overhead in the creation of the event classes for each action.
2. Has a large entry threshold.
3. Not the best choice for [reactive](#Reactivity-2) application.
4. Has a lot of [initial boilerplate](#Initial_boilerplate_absence-2) code.
5. Has a lot of [new feature boilerplate](#New_feature_boilerplate_absence-2) code.
6. Has a low level of [maintainability](#Maintainability-2).
7. It could be [hard to learn](#Easy_to_learn-2).

## [Redux](https://pub.dev/packages/redux)

Redux is a predictable state container for Dart and Flutter apps.

**_Core concept_**

- Store
- Actions
- Middleware
- Reducers

**_The Store_** holds the application state.

**_Actions_** are payloads of information that send data from your application to your store. They are the only source of information for the store. You send them to the store using the `store.dispatch()` method.

**_Middlewares_** allows you to do something before your action access to the reducer.

**_Reducers_** specify how the application's state changes in response to actions.

**_Concept in action_**:

1. You call `store.dispatch(Action)`.
2. The Redux Store calls your reducer with the previous state and dispatched action.
3. Your Reducer will return a new AppState.
4. The Redux Store will save the new AppState and notify all components listening to the onChange Stream that a new AppState exists.
5. When the State changes, you rebuild your UI with the new State.

### Code sample

First of all, need to create our central source of truth - the Store.

```dart
 final Store<AppState> store =
      Store<AppState>(...our reducer, initialState: ...);
```

To inject the store into UI, we need to use `StoreProvider` widget.

```dart
@override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(...
```

Our UI now interacts with the central Store using actions. So we need to create them, for example, for sign-in (`class SignInAction{}`) and sign out (`class SignOutAction{}`).

```dart
RaisedButton(
  onPressed: () {
    store.dispatch('signInAction')
    //or
    store.dispatch('signOutAction')
  },
```

The reducer will handle incoming old store and action, `signInReducer(Store store, SignInAction action)`, and returns a new store with new values.

UI rebuilds every time Store changes with `StoreConnector` widget. It has `converter` function, that can filter all data to get an only specific list of them and `builder` that is getting viewModel with filtered data and return UI:

```dart
child: StoreConnector<AppState, AppState>(
    converter: (store) => store.state,
    builder: (context, viewModel) {
        return ...
    }
)
```

### Conclusion

#### Asynchronous

Middleware is a part of Redux, that helps to do some asynchronous actions, like API calls.

An example, of how we can use a middleware to asynchronously load projects:

In the `middlewares.dart` we can define our middlewares.

```dart
  // middlewares.dart
  class AppMiddleware {
    List<Middleware<AppState>> get middleware => [
      TypedMiddleware<AppState, LoadProjectsAction>(loadProjectsMiddleware),
    ]
  }

  loadProjectsMiddleware(Store<AppState> store, LoadProjectsAction action, NextDispatcher next) async {
    try {
      final projects = await loadProjects(); // our API call
      store.dispatch(new LoadProjectsSucceededAction(items))
    } catch (error) {
      store.dispatch(new LoadProjectsFailedAction(error));
    }

    next(action)
  }
```

And now we can import our middlewares to the `main.dart` file and inject it to the `StoreProvider` to actually use it.

```dart
  // main.dart
   final Store<AppState> store =
      Store<AppState>(
        middlewares: AppMiddleware().middleware,
      );

    ...
    @override
      Widget build(BuildContext context) {
        return StoreProvider<AppState>(
          store: store,
          child: MaterialApp(...
```

Redux works well with asynchronous actions, as we can see in the code example above. Any our async functions or API calls we can place inside middlewares.

The complicated part of this, that we need to create middleware for each asynchronous action we want to implement.

Score: 3.

#### Reactivity

To work with Streams in Redux we need an additional package - [epic_redux](https://pub.dev/packages/redux), that offers a new type of middleware.

Example of how we can update our list of projects in our store, based on the external storage changes in project list.

```dart
import 'dart:async';
import 'package:redux_epics/redux_epics.dart';

Stream<dynamic> projectsEpic(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) {
  return new Observable(actions)
    // Filter all actions to get only specific one
    .whereType<LoadProjectsAction>()
    .switchMap((LoadProjectsAction action) {
      return _getProjects(store).asyncMap((projects) async {
        // action to synchronously mutate the state
        return SetProjectsActions(projects: projects);
    }).takeUntil(
        // close our stream
        actions.where((action) => action is CancelLoadProjectsAction),
    );
  });
}

// Set our notifier, to notify us if projects have changed
Observable<List<Project>> _getProjects(store) {...}
```

Inject our epic middleware into the `store`:

```dart
import 'package:redux_epics/redux_epics.dart';
import 'package:redux/redux.dart';

var epicMiddleware = new EpicMiddleware(projectsEpic);
var store = new Store<State>(..., middleware: [epicMiddleware]);
```

So, Redux works pretty good with `streams`, but requires an additional `epic_redux` package, which adds specific to the package way to interact with them. This imposes some complexity working with `streams`.

Score: 3.

#### Boilerplate

To add Redux to the project, we need to create `Store` object, which will hold our application state. Each action of the app requires corresponding `Action` and `Reducer`, which mutates the state. If we need to do asynchronous work - `Middleware` comes into play.

To inject our store into UI, we use `StoreProvider` and access the store, using `StoreConnector`.

So it is a lot of classes, functions and widgets to the initial boilerplate, that provides a lot of files to initialize the Redux.

To add a new feature to the app, we need to create `Action` and either `Middleware` if we plan to make API calls or `Reducer` if we plan to mutate the state.

Score: 1

#### Maintainability

Separation of the business logic and the UI, predictable changes, centralized Store, unidirectional data flow make apps, based on Redux, highly maintainable.

Also, having actions, middlewares, reducers help us to easy scale and add new functionality to the app.

On the other hand, this overhead makes adding or editing a feature as a complex task.

#### State snapshot

As we have a single application `Store` we can make a snapshot of the state in any time we want.

Score: 5

#### Debugging

The business logic, that is separated into `actions`, `middlewares` and `reducers` make it easy to debug the application. Also, unidirectional data flow makes our changes predictable. Also, the central `Store` allows us to print the application `state` in any time.

There are useful tools to debug, such us [redux_dev_tools](https://pub.dev/packages/redux_dev_tools). It allows you to travel back and forth throughout the `State` of your application. There is a wrapper of the package, made to work with flutter - [flutter_redux_dev_tools](https://pub.dev/packages/flutter_redux_dev_tools).

Score: 5

#### Undo/Redo actions

There is a [redux_undo](https://github.com/fluttercommunity/redux_undo) package, that adds undo/redo functionality, jump to the past or to the future through some steps, clear all history.

Score: 5

#### Testability

We have separate pieces of the business logic - `actions`, `middlewares`, and `reducers` so we can isolate each part for testing purposes.

Also, the Redux concept is one input - action, and one output - reducer, a middleware, that lies between these two. Each of them responsible for doing a little part of the logic and is separated, so we can easily test it.

Score: 5

#### Easy to learn / Namings

Redux is hard to learn, because of its key concept, which is not clear to newcomers with this state management. Too many different parts that you need to understand: `store`, `actions`, `middleware`, `reducers`.

The package has the same concept as `redux.js`, so if you have experience working with it, `flutter_redux` will be understandable for you.

Namings in Redux is not intuitive, and at first it is hard to understand what middleware or reducers are used for.

Score: 1

#### Analytics\Centralized

Score:

#### State Mutability/Immutability

The application `state` in Redux is immutable and it is a core concept. The only way to mutate the `state` is to `dispatch` an `action`.

Score: 5

#### Flutter integration/Reusability

The [redux](https://pub.dev/packages/redux) package developed to work with `Dart`. So we can use Redux outside of `flutter`.

To work with `flutter` there is a [flutter_redux](https://pub.dev/packages/flutter_redux) package, so we have a good flutter integration.

Also, business logic is separated from the UI and split into `actions`, `middlewares`, `reducers`, so we can easily reuse the code.

Score: 5

#### Pros

1. [Asynchronous](#Asynchronous-3) is a part of Redux, but need to create separate functions to do some asynchronous stuff.
2. It has a high level of [maintainability](#Maintainability-3).
3. You can make [state snapshots](#State-snapshot-3).
4. Easy to [debug](#Debugging-3).
5. Support [Undo/Redo](#Undo/Redo-actions-3) actions.
6. Good [testability](#Testability-3).
7. [State Mutability/Immutability](#State-Mutability/Immutability-3) is a core concept.
8. [Flutter integration/Reusability](#Flutter-integration/Reusability-3)
9. Store changes are perfectly predictable.
10. Unidirectional data flow.

### Cons

1. It has a support of [reactivity](#Reactivity-3) but needs to add a separate package.
2. It requires a lot of [boilerplate](#boilerplate-3).
3. [High learning curve](#Easy-to-learn-3).
4. The store will get very large with large applications.
5. Every widget can access to the global store.

## [Provider](https://pub.dev/packages/provider)

The provider is the state management mechanism based on the flutter `InheritedWidget`, that can expose any kind of state object, including BLoC, streams, futures, and others. Because of its simplicity and flexibility, Google announced at Google I/O ’19 that Provider is now its preferred package for state management.

**_Core concepts:_**

1. `ChangeNotifier` - a simple class that provides change notification to its listeners.
2. `ChangeNotifierProvider` - a widget that provides an instance of a ChangeNotifier to its descendants.
3. `Consumer` - a widget, that rebuilds specific parts of the UI, whenever the obtained value changes and helps to access the instance of ChangeNotify.

### Code sample

To manage the state of the `AuthStore`, we need to extend the `ChangeNotifier` class.

```dart
class AuthStore extends ChangeNotifier {}
```

With that in place, we can now use `notifyListeners()` method to indicate that our state was changed.

```dart
class AuthStore extends ChangeNotifier {
  ...
  void signInWithEmailAndPassword(String email, String password) {
    // Some actions going on here
    notifyListeners();
  }
  ...
}
```

In the UI, we need to use the `ChangeNotifierProvider` widget to inject our class. It listens to a `ChangeNotifier`, exposes it to its descendants, and rebuilds dependents whenever `notifyListeners()` is called.

```dart
...
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => AuthStore(),
        child: ...
```

The easiest way to read value is by using the static method `Provider.of<T>(BuildContext context)`.
This method will look up in the widget tree for `Provider<T>` class, starting from the widget associated with the BuildContext passed, and return the value of the nearest one (or throw if nothing is found).

Alternatively, instead of using the `Provider.of`, we can use the `Consumer` widget:

```dart
...
child: Consumer<AuthStore>(
  builder: (context, authStore, child) {
    ...
  },
),
```

Also, there is the `Selector` widget - equivalent to the Consumer that can filter updates by selecting a limited amount of values and prevent rebuild if they don't change.

The package works well with Future and Streams via:

1. `FutureProvider` widget used to provide data into the asynchronous widget tree.
2. `StreamProvider` widget, designed to allow widgets access to the state, which occurs as part of a stream.

### Conclusion

#### Asynchronous

To asynchronously update the UI, based on `projects`, we can invoke `notifyListeners` method after we update `projects` value.

```dart
class ProjectsChangeNotifier extends ChangeNotifier {
  List<Project> projects;

  Future<void> getProjects() async {
    projects = await _repository.getProjects();

    notifyListeners();
  }
}
```

And with injected our `ProjectsChangeNotifier` using `ChangeNotifierProvider`:

```dart
...
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ProjectsChangeNotifier(),
        child: ...
```

we can rebuild the UI, using `Consumer` widget:

```dart
  Consumer(
    builder: (context, List<Project> projects, child) {
      return AnotherWidget();
    }
  ),
```

There is, also, a `FutureProvider` widget. It listens for when the Future completes and then notifies the `Consumers` to rebuild their widgets.

If we have a function `getProjects`, that asynchronously returns a list of `Project`, we can inject this async function into `FutureProvider`:

```dart
...
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureProvider<List<Project>>(
        create: (context) => getProjects(),
        child: ...,
```

With that we can use `Consumer` widget to get the projects, after our Future resolves.

```dart
...
  Consumer<List<Project>>(
    builder: (context, projects, child) {
      return AnotherWidget();
    }
  )
...
```

The Provider is good with asynchronous. We have different ways to handle async work and it is not a complex task.

Score: 5

#### Reactivity

The package is pretty good work with reactivity.

Let's say we need to rebuild our UI, based on the changes in some `projectsStream`. For that, we should invoke `notifyListeners` each time new values come to the stream.

```dart
class ProjectChangeNotifier extends ChangeNotifier {
  List<Project> projects;

  void subscribeToProjects() {
    ...

    projectsStream.listen((projects){
      projects = projects;

      notifyListeners();
    });
  }
}
```

With that in place, and after injected our `ProjectChangeNotifier` using `ChangeNotifierProvider`:

```dart
...
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ProjectChangeNotifier(),
        child: ...
```

we can rebuild the UI, using `Consumer` widget:

```dart
...
  Consumer<List<Project>>(
    builder: (context, projects, child) {
      return AnotherWidget();
    }
  )
...
```

Also, there is a useful widget - `StreamProvider`, which listens to a `stream` and exposes its content to child and descendants.

```dart
class AuthChangeNotifier extends ChangeNotifier {
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  Stream<bool> get loggedInStream => _isLoggedInSubject.stream;
}
```

In our widget we inject `stream` into the `StreamProvider`:

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamProvider<bool>(
        stream: AuthChangeNotifier.loggedInStream,
        child: ...,
```

And read `stream's` value in `Consumer` widget:

```dart
  Consumer(
    builder: (context, bool isLoggedIn, child) {
      // build widget, based on isLoggedIn value
      return AnotherWidget();
    }
  ),
```

So, the support of reactivity is pretty good too. We have different ways to work with streams, as well as async.

Score: 5

#### Boilerplate

To initialize the Provider as state management of the application, all we need to make our class `extends ChangeNotifier` and place `notifyListener` to our method to call all the registered listeners.
With that we can use widgets, provided by the package, such as `ChangeNotifierProvider`, to rebuild the UI.

To add a new feature we either add `notifyListener` to a new method or add a separate class with extending the `ChangeNotifier` class. So, in most cases, we don't need to create new files, and just create methods in the existing ones. If the feature requires their own state with the logic, we just need to create a separate class.

So, the boilerplate level of the Provider package is very low. Usually, all we have to do is to extend the class and add method, that triggers the rebuild out UI.

Score: 5

#### Maintainability

It is good for small and medium apps, because requires a minimum code to implement features.

#### State snapshot

We cannot make a state snapshot, because of separated models with their own states (no global single state), but we can track each of the model's state on a different stage of the app.

#### Debugging

With `Provider` package we have a simple concept of `changes/rebuilds`, based on pure functions, so we can use debugger to fix issues in the application code.
Also, because the `notifyListeners` affects only subscribed listeners, we can find possible errors in predictable places.

Score: 5

#### Undo/Redo

The Provider package has no support of a feature, like undo/redo.

Score: 0

#### Testability

With the Provider we can use pure Dart classes, a major part of the logic is focused on using public methods to interact with the logic components so we can easily test it with unit tests.

Score: 5

#### Easy to learn/ Namings

It has an easy basic concept, consist of `ChangeNotifier`, `ChangeNotifierProvider`, and `Consumer` that easy to understand. Also, these concept and namings are intuitive to understand.

Score: 5

#### Analytics\Centralized

Score:

#### State Mutability/Immutability

There is no concept of immutability in the Provider package. We can just use private values and provide getters to add an encapsulation to the model.

Score: 2

#### Flutter integration/Reusability

The Provider is based on the flutter's [foundation library](https://api.flutter.dev/flutter/foundation/foundation-library.html), that provides access to the `ChangeNotifier` class.

Score:

### Pros

1. [Easy to learn](#easy-to-learn-4).
2. Requires a low level of the [boilerplate](#boilerplate-4).
3. It has a good level of [maintainability](#Maintainability-4) in small and medium apps.
4. Easy to [debug](#Debugging-4).
5. Has a good [testability](#Testability-4).
6. Has a good [flutter integration](#Flutter-integration/Reusability-4).
7. UI logic and business logic are separated.
8. There are useful widgets, for different purposes, such as:
   - `ChangeNotifierProvider` - Listens to a `ChangeNotifier`, expose it to its descendants and rebuilds dependents whenever the `notifyListeners()` is called.
   - `MultiProvider` - It's a list of all the different Providers being used within its scope.
   - There are more: `StreamProvider`, `FutureProvider`, `ListenableProvider`, `ValueListenableProvider` etc.

### Cons

1. Can't make [state snapshots](#State-snapshot-4).
2. Doesn't have a possibility to [Undo/Redo](#Undo/Redo-4) actions.
3. Hard to make [analytics](#Analytics\Centralized-4).
4. [State mutability/Immutability](#State-Mutability/Immutability-4).
5. Preferable in small and middle-sized projects.
6. It might be hard to rebuild the UI granularly.

## [State notifier](https://pub.dev/packages/state_notifier)

This package reimplements the `ValueNotifier` outside of Flutter.

A value notifier is a ChangeNotifier that holds a single value. When the value replaced with something that is not equal to the old value as evaluated by the equality operator ==, this class notifies its listeners.

The motivation of the package is to extracting ValueNotifier outside of Flutter in a separate package to allowed Dart packages with no dependency on Flutter to use these classes.

### Code sample

To create our notifier, we need to extend the `StateNotifier` class. It is an observable class that stores a single immutable state.

```dart
class AuthStateNotifier extends StateNotifier<AuthState> {
    AuthStateNotifier() : super(AuthState());
}
```

For a reading, StateNotifier gives us a `state` - the protected property, that is used only by subclasses of StateNotifier.

To update the state, just set the new state to the `state` variable. Updating the value will synchronously call all the listeners.

```dart
super.state = newState;
```

To subscribe to the `AuthState` updates, use the `addListener` method.

```dart
final authNotifier = AuthStateNotifier();
authNotifier.addListener((value) => ...);
```

To remove the listener from the object, the `addListener` method returns a `removeListener` function, that we can save to the variable and call later.

```dart
final authNotifier = AuthStateNotifier();
final removeAuthListener = authNotifier.addListener((value) => ...);
...
removeAuthListener();
```

To work with things, like `Provider.of` (from the provider flutter's package) or GetIt (get_it package) `LocatorMixin` exists. It provides the interface for the 3rd party libraries.

```dart
class AuthStateNotifier extends StateNotifier<AuthState> with LocatorMixin {
    AuthStateNotifier() : super(AuthState());
}
```

With this, we can use [flutter_state_notifier](https://pub.dev/packages/flutter_state_notifier#-readme-tab-) package - a binding between state notifier and Flutter. It adds things like `ChangeNotifierProvider` from the provider package, but compatible with the state_notifier.

```dart
...
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateNotifierProvider<AuthStoreNotifier, AuthStore>(
        create: (context) => AuthStoreNotifier(),
        child: ...
```

### Conclusion

#### Asynchronous

The same as in Provider package, read [here](#Asynchronous-4).

#### Reactivity

The same as in Provider package, read [here](#Reactivity-4).

#### Initial boilerplate absence

All we need to make our class that represents state `extends ValueNotifier` and place `notifyListener` to our method to call all the registered listeners.
With that we can use widgets, provided by the [State notifier flutter](https://pub.dev/packages/flutter_state_notifier) package to rebuild the UI.

#### New feature boilerplate absence

To add a new feature we either add `notifyListener` to a new method or add a separate class with extending the `ValueNotifier` class.

#### Maintainability

The same as in Provider package, read [here](#Maintainability-4).

#### State snapshot

The same as in Provider package, read [here](#State-snapshot-4).

#### Debugging

As the package is good for small and medium apps, it is easy to debug because of simple concept of changes/rebuilds.
Also, because the `notifyListeners` affects only subscribed listeners, so we can find possible errors in predictable places.
Debug level is decreasing while going to the large app.

#### Undo/Redo

The same as Provider package, read [here](#Undo/Redo-4)

#### Testability

Easy to mock methods of the class makes high level of testability.
One of the useful method is `debugMockDependency`, that overrides `read` method of `LocatorMixin` to mock its behavior in development.

#### Easy to learn

The same as Provider package, read [here](#Easy-to-learn-4)

### Pros

1. Based on the pure dart, so the business logic could be reused in a non-flutter application.
2. Great support for [reactivity](#Reactivity-5) and [asynchronous](#Asynchronous-5) programming.
3. Requires a low level of the [initial boilerplate](#Initial-boilerplate-absence-5).
4. To add a new feature needs only a [few files](#New-feature-boilerplate-absence-5).
5. It has a good level of [maintainability](#Maintainability-5) in small and medium apps.
6. Easy to [debug](#Debugging-4).
7. Has a good [testability](#Testability-4).
8. Simple embedded mechanism of state listeners notification. You should just set a new state, and the `StateNotifier` will notify all the listeners.
9. The application state and business logic are separated.

### Cons

1. No ability to rebuild the widget tree granular. If the state changes - all listeners are notified.
2. A pretty young plugin.
3. Can't make [state snapshots](#State-snapshot-5).
4. Doesn't have a possibility to [Undo/Redo](#Undo/Redo-5) actions.
5. Preferable in small and middle-sized projects.

# Glossary

- Asynchronous -
- Reactivity
- Boilerplate -
- Maintainability -
- State snapshot -
- Debugging -
- Undo/Redo actions -
- Testability -
- Easy to learn -
- State Mutability / Immutability -
- Flutter integration / Reusability -
- Analytics/Centralized -

# Results

> What was the outcome of the project?
