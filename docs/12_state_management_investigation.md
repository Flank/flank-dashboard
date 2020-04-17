# Metrics Web state management

> Summary of the proposed change

Choose the best state management for the Metrics Web application.

# References

> Link to supporting documentation, GitHub tickets, etc.

- [Bloc pattern](http://flutterdevs.com/blog/bloc-pattern-in-flutter-part-1/)
- [Bloc package](https://www.netguru.com/codestories/flutter-bloc)
- [Provider](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple)
- [Provider package](https://pub.dev/packages/provider)
- [States rebuilder](https://github.com/GIfatahTH/states_rebuilder)
- [State notifier](https://pub.dev/packages/flutter_state_notifier)

# Motivation

> What problem is this project solving?

Choosing the best state management mechanism will simplify the development process.

# Goals

> Identify success metrics and measurable goals.

The main goal of this project to shortly describe the most popular state management mechanisms and chose the bast one for our application.

# Non-Goals

> Identify what's not in scope.

Switching to new state management mechanism is out of scope.

# Design

> Explain and diagram the technical design

`UI` -> `State management` -> `Application State` -> `UI`

> Identify risks and edge cases

# API

> What will the proposed API look like?

# Dependencies

> What is the project blocked on?

> What will be impacted by the project?

# Testing

> How will the project be tested?

# Alternatives Considered

> Summarize alternative designs (pros & cons)

## BLoC pattern

The BLoC is an architectural pattern that functions as a state management solution. All business logic is extracted from the UI into BLoC (Business Logic Components). The UI should only publish events to the BLoCs and display the UI based on the state of the BLoCs.

### Code sample

Assume we have an `AuthBloc` that provides an ability to signIn a user and holds current authentication state.

```
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

So, to subscribe to the auth updates we should subscribe to `isLoggedInStream` whether using the regular listener function `isLoggedInStream.listen(...)` or using the `StreamBuilder` to update the UI based on the current stream value.
If wee want to sign in a user we have a `Sink`, so we should call `signInSink.add(credentials)` to trigger the sign in process.

### Pros

1. Has clear architectural rules. It implies using the stream for communication between UI and BLoC and two separate blocks. In simple words - nothing except streams and sinks available from outside of the BLoC.
2. It is easy to trace and debug the application state changes when you have only one way to change it - the sink.
3. Easy to test and debug the business logic.
4. The widget tree could be rebuilt granular only when the data for the exact subtree is changed.
5. Easy to subscribe to the application state updates outside of the UI.
6. Has the great support of reactivity.

### Cons

1. Relatively large entry threshold if you are not familiar with streams and [rxdart](https://pub.dev/packages/rxdart) library.
2. Has an overhead because you should create a separate stream for API response results, etc.

## States Rebuilder

States Rebuilder if the package for flutter built on the observer pattern for state management and the service locator pattern for dependency injection. It is very similar to the Provider package but has a couple of additional features that make building the UI a bit easier.

### Code sample

Assume we have the `AuthStore` that should provide the same functionality as the `AuthBloc`.

```
class AuthStore {
  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  Stream<bool> get loggedInStream => _isLoggedInSubject.stream;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    /// sign in logic
    _isLoggedInSubject.add(true);
  }
}
```

In this case to subscribe to the authentication updates in the UI we should:

1.  We should inject this stream.

        ```
        Injector(
            inject: [
                Inject<AuthStore>(() => AuthStore()),
                Inject.stream(() => Injector.get<AuthStore>().loggedInStream),
            ],
            builder: (BuildContext context) => widget.child,
        );
        ```

2.  Create a StateRebuilder widget and build the UI accordingly to the model state.

        ```
            StateBuilder(
              models: [Injector.getAsReactive<bool>()],
              builder: (_, model){
                  return model.whenConnectionState(...);
              },
            );
        ```

If we want to subscribe to the authentication updates outside of the UI we can call `loggedInStream.listen()`.

In case we want to subscribe to the application state updates we should:

1. Implement the `ObserverOfStatesRebuilder`.
2. Implement the `update` method to react to `AuthStore` updates.

The code sample of the application state subscription is shown below:

```
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

### Pros

1. Provides a useful methods `onError`, `onWaiting`, etc. to build the UI.
2. Has embedded dependency injection.
3. Relatively simple for beginners.
4. Suitable for applications that have a lot of asynchronies.

### Cons

1. Not so great support of reactive features (streams, etc).
2. Has complex mechanism of subscription to the application state updates.
3. Has complex mechanism of subscription to any streams inside of the state from the UI.
4. Has bad support of reactivity.

## BLoC library

The Bloc library is the package, used for managing the application state, which is based on the Redux concept.

### Code sample

Still the same `AuthBloc`, but now we should create a separate class for out authentication state, let's call it `AuthState`:

```
class AuthState {
  final bool isLoggedIn;


  AuthState copyWith({bool isLoggedIn}) {
    ...
  }
  ...
}
```

Also, we should create the `AuthEvent` abstract class - the base class for all events that used to interact with our `AuthBloc` and mutate the `AuthState`:

```
abstract class AuthEvent {}
```

Finally, we can create our `AuthBloc`:

```
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  @override
  AuthState get initialState => AuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    ...
  }
}
```

Extending the `Bloc` class we should implement two methods:

- the `initialState` getter that should return the initial state of our `AuthStore`
- the `mapEventToState` method that will receive the dispatched `AuthEvent`s and should yield a new `AuthState` on each event.

To add the functionality to our bloc we should:

1. Add a new event called `SignInAuthEvent`

   ```
   abstract class AuthEvent {}
   ```

2. Add implementation of the sign in to the `mapEventToState` method:

   ```
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

```
BlocProvider(
  create: (BuildContext context) => AuthBloc(),
  child: ...,
);
```

Now the `AuthBloc` is available for all down-laying widgets, so we can use the `BlocBuilder` or the `BlocConsumer` widgets to build your UI in respect of the current application state.

```
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    // return widget here based on AuthBloc's state
  }
)
```

To start the sign in process it is needed to call the `BlocProvider.of<AuthBloc>(context).add(SignInAuthEvent(...))` method.

### Pros

1. Nicely-divided business logic from the application state.
2. Understandable data flow: `UI` -> `Action` -> `Bloc` -> `New State` -> `UI`
3. Embedded dependency injection mechanism.
4. Nice support of asynchrony.

### Const

1. Overhead in creation of the event classes for each action.
2. Not the best choice for reactive application.
3. Has large entry threshold.
4. Bad support of reactivity.

## Redux

Redux is a predictable state container for Dart and Flutter apps

**_Core concepts_**

1. Actions
2. Middleware
3. Reducers
4. Handling Actions with Reducers
5. Stores

**_Actions_** are payloads of information that send data from your application to your store. They are the only source of information for the store. You send them to the store using the `store.dispatch()` method.
**_Middlewares_** allows you to do something before your action access to the reducer.
**_Reducers_** specify how the application's state changes in response to actions.
**_Store_** holds the application state.

**_Core concepts in action_**:

1. You call `store.dispatch(Action)`.
2. The Redux Store calls your reducer with the previous state and dispatched action.
3. Your Reducer will return a new AppState.
4. The Redux Store will save the new AppState and notify all components listening to the onChange Stream that a new AppState exists.
5. When the State changes, you rebuild your UI with the new State.

### Code sample

First of all, need to create our central source of truth - the Store.

```
 final Store<AppState> store =
      Store<AppState>(...our reducer, initialState: ...);
```

To inject store into UI we need to use `StoreProvider`

```
@override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(...
```

Our UI now interacts with the central Store using actions, not via functions directly. So we need to create them, for example, for sign-in (`class SignInAction{}`) and sign out (`class SignOutAction{}`).

```
RaisedButton(
  onPressed: () {
    store.dispatch('signInAction')
    //or
    store.dispatch('signOutAction')
  },
```

The reducer will handle incoming old store and action, `signInReducer(Store store, SignInAction action)` and returns a new store with new values.

UI rebuilds every time Store changes with `StoreConnector` widget. It has `converter` function, that can filter all data to get only specific list of them and `builder` that is getting viewModel with filtered data and return UI:

```
child: StoreConnector<AppState, AppState>(
    converter: (store) => store.state,
    builder: (context, viewModel) {
        return ...
    }
)
```

### Pros

1. A lot of useful tools, that helps in development, testing and debugging:
   redux_dev_tools - A Time-Traveling Redux Debugger for Flutter
   redux_logging - A Middleware that prints the latest action & state
   redux_epics - A Middleware that helps you perform side effects using Streams
   flutter_redux_navigation - A simple reactive navigation middleware for Flutter's redux library.
   ...
2. It helps you write applications that behave consistently and are easy to test.
3. Unidirectional data flow
4. Single Source of Truth - the state of the whole application is stored in an object tree within a single store.
5. Store changes are perfectly predictable.
6. Middlewares - allows for side effects to be run without blocking state updates (like API calls or logging).

### Cons

1. High learning curve
2. The store will get very large with large applications
3. Every widget can access to the global store

## Provider

It is a wrapper around InheritedWidget, that can expose any kind of state object, including BLoC, streams, futures, and others. Because of its simplicity and flexibility, Google announced at Google I/O ’19 that Provider is now its preferred package for state management.

**_Core concepts:_**

1. ChangeNotifier - a simple class that provides change notification to its listeners.
2. ChangeNotifierProvider - a widget that provides an instance of a ChangeNotifier to its descendants.
3. Consumer - a widget, that rebuilds specific parts of the UI whenever the obtained value changes and helps to access the instance of ChangeNotify.

### Code sample

To manage the state of the `AuthStore`, we need to extend the `ChangeNotifier` class.

```
class AuthStore extends ChangeNotifier {}
```

With that in place, we can now use `notifyListeners()` method to indicate that our state was changed.

```
class AuthStore extends ChangeNotifier {

  void signInWithEmailAndPassword(String email, String password) {
    // Some actions going on here
    notifyListeners();
  }

}
```

In the UI we need to use `ChangeNotifierProvider` widget to inject our class. It listens to a `ChangeNotifier`, exposes it to its descendants and rebuilds dependents whenever `notifyListeners()` is called.

```
...
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => AuthStore(),
        child: ...
```

The easiest way to read value is by using the static method `Provider.of<T>(BuildContext context)`.
This method will look up in the widget tree starting from the widget associated with the BuildContext passed and it will return the nearest variable of type T found (or throw if nothing is found).

Alternatively instead of using `Provider.of`, we can use the `Consumer` widget:

```
...
child: Consumer<AuthStore>(
  builder: (context, authStore, child) {
    return RaisedButton(
      onPressed: () {
        authStore.signInWithEmailAndPassword(email, password);
      },
    );
  },
),
```

Also, there is the `Selector` widget - equivalent to the Consumer that can filter updates by selecting a limited amount of values and prevent rebuild if they don't change.

The package works well with Future and Streams via:

1.  `FutureProvider` widget, that is used to provide data into the widget tree that is asynchronous.
2.  `StreamProvider` widget, that is designed to allow widgets to access state which occurs as part of a stream.

### Pros

1. Easy to learn.
2. UI logic and business logic are separated.
3. testability/composability: `ChangeNotifier` is part of `flutter:foundation` and doesn’t depend on any higher-level classes in Flutter.
4. there are useful widgets, for different purposes, such as:
   `ChangeNotifierProvider` - Listens to a `ChangeNotifier`, expose it to its descendants and rebuilds dependents whenever the `notifyListeners()` is called.
   `MultiProvider` - It's a list of all the different Providers being used within its scope.
   There are more: `StreamProvider`, `FutureProvider`, `ListenableProvider`, `ValueListenableProvider` etc.

### Cons

1. Preferable in small and middle-sized projects.
2. It might be hard to rebuild the UI granularly.

## State notifier

This package reimplements the `ValueNotifier` outside of Flutter.

A value notifier is a ChangeNotifier that holds a single value. When the value is replaced with something that is not equal to the old value as evaluated by the equality operator ==, this class notifies its listeners.

The motivation of the package is to extracting ValueNotifier outside of Flutter in a separate package to allowed Dart packages with no dependency on Flutter to use these classes.

### Code sample

To create our notifier we need to extend `StateNotifier` class. It is an observable class that stores a single immutable state.

```
class AuthStateNotifier extends StateNotifier<AuthState> {
    AuthStateNotifier() : super(AuthState());
}
```

For a reading, StateNotifier gives us a **_state_** protected property, that is used only by subclasses of StateNotifier. To get the state from outside of the class, **\*addListener** method.

To update the state you can override **_state_** setter. Updating the value will synchronously call all the listeners.

```
@override
@protected
set state(AuthState newValue) {
    super.state = newValue;
}
```

To subscribe on the AuthState updates we can use **_addListener_** method.

```
final authNotifier = AuthStateNotifier();
authNotifier.addListener((value) => ...);
```

To remove listener from the object, **_addListener_** method returns a **_removeListener_** function, that we can save to the variable and call later.

```
final authNotifier = AuthStateNotifier();
final removeAuthListener = authNotifier.addListener((value) => ...);
...
removeAuthListener();
```

To work with things, like Provider.of (from the provider flutter's package) or GetIt (get_it package) `LocatorMixin` exists. It provides the interface for the 3rd party libraries.

```
class AuthStateNotifier extends StateNotifier<AuthState> with LocatorMixin {
    AuthStateNotifier() : super(AuthState());
}
```

With this, we can use **_flutter_notifier_** package - a binding between state*notifier and Flutter. It adds things like \*\*\_ChangeNotifierProvider*\*\* from the provider package, but compatible with the state_notifier.

```
...
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateNotifierProvider<AuthStoreNotifier, AuthStore>(
        create: (context) => AuthStoreNotifier(),
        child: ...
```

### Pros

1. Based on the pure dart, so the business logic could be reused in non-flutter application.
2. Great support for reactivity and asynchronies.
3. Simple embedded mechanism of state listeners' notification. You should just set a new state, and the `StateNotifier` will notify all the listeners.
4. The application state and the business logic are separated.

### Cons

1. Unable to update the application state without rebuilding the UI. ??
2. No ability to rebuild the widget tree granular. If the state changes - all listeners are notified.
3. A pretty young plugin.

# Timeline

> Document milestones and deadlines.

DONE:

-

NEXT:

-

# Results

> What was the outcome of the project?
