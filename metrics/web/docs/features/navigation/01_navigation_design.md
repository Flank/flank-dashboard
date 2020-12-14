# Navigator 2.0 design

## TL;DR

Introducing Flutter’s new navigation and routing system into the Metrics Web Application allows us to make the application more comfortable in using and improve the user experience overall by solving such problems as back and forward navigation. 

## References
> Link to supporting documentation, GitHub tickets, etc.
* [Learning Flutter’s new navigation and routing system](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade)
* [Router class](https://api.flutter.dev/flutter/widgets/Router-class.html)
* [MaterialApp with Router](https://api.flutter.dev/flutter/material/MaterialApp/MaterialApp.router.html)
* The [example](https://github.com/orestesgaolin/navigator_20_example/blob/master/lib/main_router.dart) of using Navigator 2.0

## Goals
> Identify success metrics and measurable goals.
* Browser back and forward navigation behaves as expected. 
* A clear design of the new navigation system integration.


## Design
> Explain and diagram the technical design

Consider the following classes, that represents the architecture of the `Navigation 2.0`.

### Router

The `Router` is a class, that listens for routing information from the operating system(e.g. browser), parses that information using the [Route Information Parser](#route-information-parser) into a user provided configuration([Route Configuration](#route-configuration)) and then [Router Delegate](#router-delegate) uses it to build the list of pages widget.

Consider the following parts of the `Router` class:

 - The [Route Information Provider](#route-information-provider) responsible for listening to the events from the operating system and send events back to it if the app state changes;
 - the [Route Information Parser](#route-information-parser) parses route information into user defined configuration and vice versa;
 - the [Router Delegate](#router-delegate) takes configuration from the `RouteInformationParser` and builds a list of pages.

### Route Information Provider

The `RouteInformationProvider` - a class that provides a [Route information](#route-information) for the [Route Information Parser](#route-information-parser).

This class is a "bridge" between the browser and the `Router`. 

When a user enters a URL in the browser, the `RouteInformationProvider` converts the URL into the [Route information](#route-information) and provides a result to the [Route Information Parser](#route-information-parser).

Also, when the application changes its state, the `RouteInformationProvider` receives the updated [Route information](#route-information) and provides the change to the browser to make reflecting changes.

The Flutter framework provides the default `RouteInformationProvider` implementation, so there is no need to implement it for the `Metrics application`.

#### Route information

A `Route information` is a class, that consists of a `location` string of the application and a `state` object that configures the application in that location.

The `location` is multiple string identifiers with slashes in between(e.g. '/route'). In the Web application it is a URL.

The `state` is an object that stores data in the browser history entry(e.g. filled input forms, scroll position).

### Route Information Parser

The `RouteInformationParser` - is a class that acts in two ways:

 - Parses an incoming [Route information](#route-information), obtained from the [Route Information Provider](#route-information-provider) into a user-defined [Route Configuration](#route-configuration);

 - creates a new [Route information](#route-information) object from the [Route Configuration](#route-configuration) and passes it back to the [Route Information Provider](#route-information-provider).

To handle our specific routes, we should define our own parser - `AppRouteInformationParser` that extends the `RouteInformationParser` and provides two methods:

```dart
class AppRouteInformationParser extends RouteInformationParser<RouteConfiguration> {
    @override
    Future<RouteConfiguration> parseRouteInformation(RouteInformation routeInformation);

    @override
    RouteInformation restoreRouteInformation(RouteConfiguration configuration);
}
```

The `parseRouteInformation` method converts the [Route information](#route-information) into the [Route Configuration](#route-configuration) and pass it to the [Route Delegate](#route-delegate) class.

The `restoreRouteInformation` method converts the [Route Configuration](#route-configuration) back into the [Route information](#route-information).

These methods exist to keep the URL in the browser's location bar up to date with the application state, allowing its back and forward buttons to function as the user expects.

The class, that helps in parsing route information - [Route Configuration Factory](#route-configuration-factory).

#### Route Configuration

The class, that holds the data that describes the route. 

It contains the route name, URL path, and the information about requiring authentication status of this route.

### Route Delegate

The `RouteDelegate` uses to build the `Navigator` with a list of configured pages. It defines how the `Router` reacts to changes in the application state and operating system.

It is a core part of the `Router` and it is responsible for:
 - react to push and pop route intents;
 - notifies the `Router` to rebuild;
 - act like a builder for the `Router`, that builds the `Navigator` widget.

To specify our own app-specific behavior we should extend the `RouteDelegate` with `ChangeNotifier` and `PopupNavigatorRouterDelegateMixin` mixins and must provide the following methods:

```dart
class AppRouteDelegate extends RouteDelegate<RouteDelegate> 
with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteDelegate> {
    @override
    RoutePath get currentConfiguration;

    @override
    Widget build(BuildContext context);

    @override
    Future<void> setInitialRoutePath(RouteConfiguration routeConfiguration);

    @override
    Future<void> setNewRoutePath(RouteConfiguration routeConfiguration);
}
```

The `currentConfiguration` is a value, that `Router` uses to populate the browser history in order to support the back and forward buttons in the browser top bar.

The `setInitialRoutePath` called by the [Router] at startup with the [RouteConfiguration](#route-configuration) from parsing the initial route.

The `setNewRoutePath` method called by the `Router` when the [Route Information Provider](#route-information-provider) reports that a new route pushed to the application by the operating system. This method takes the [RouteConfiguration](#route-configuration) that comes from the [Route Information Parser]($route-information-parser) and change the list of pages accordingly.

The `build` method builds the `Navigator` widget with a list of configured pages.

The missing part of this is the injecting the [Navigation Notifier](#navigation-notifier) into the `Router Delegate` and add listener to it, so when the `Navigation Notifier` changes it state the `Router` rebuilds.

```dart
class AppRouterDelegate extends RouterDelegate<RouteConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfiguration> {
  final NavigationNotifier navigationNotifier;

  AppRouterDelegate({
    this.navigationNotifier,
  }) {
    navigationNotifier.addListener(notifyListeners);
  }
```

### Navigation Notifier

Is a `ChangeNotifier` that is a container that contains a list of pages of the application with methods to make an actual navigation. 

Also, this class holds an information about an authentication state, to restrict visiting specific pages only by the logged users.

The `Navigator Notifier` requires two parameters:

 - [App Pages Factory](#app-pages-factory)
 - [Route Configuration Factory](#route-configuration-factory)

### App Pages Factory

The `AppPagesFactory` is a class that stands for populating actual pages, by comparing the route information that comes from the browser with the pre-defined specific to the Metrics application route configurations.

### Route Configuration Factory

The `RouteConfigurationFactory` is responsible for creating the [RouteConfiguration](#route-information) from the given `URI`.

The following diagram describes the structure and relationship between the above classes.

![Route change diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/navigation2_design_docs/metrics/web/docs/features/navigator/diagrams/navigation_class_diagram.puml)

## Making things work

The following section provide an implementation of a new navigation integration into the Metrics Web Application. As navigation is related to the UI of the application, the required changes affect only the presentation layer. Read more about layers and their responsibilities in the [Metrics Web Application architecture document](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md). 

To introduce this feature, we should follow the next steps:

1. Replace the `MaterialApp` widget in the root `main.dart` file with the new `MaterialApp.router()` constructor.
2. Create the `AppRouteInformationParser` and pass it to the `MaterialApp.router()`, as it is the first required parameter.
3. Create the `RouteConfigurationFactory` class, that helps in parsing and mapping the `RouteInformation` in the created `AppRouteInformationParser`.
4. To help with mapping an incoming `RouteInformation` to the application specific, we should define the `AppRoutes` class, that consist of pre-defined `RouteConfiguration`s that belongs to Metrics application pages.
5. Create the `AppRouterDelegate` and pass it to the `MaterialApp.router()`, as it is the second required parameter.
6. Create the `NavigationNotifier` and inject it to the application via `InjectorContainer` widget and connect it with the `AuthNotifier` to be able to update an authentication status of a user once the `AuthNotifier` changes.
7. Provide methods that should have similar to the `Navigation 1.0` API, to make navigation in the application, such as: 
 - pushNamed() and popNamed()
 - pushReplacement() and pushReplacementNamed()
 - pushAndRemoveWhere()
8. Integrate the `NavigationNotifier` into the `AppRouterDelegate` as well, to extract methods for the actual navigation and a list of pages, specific to the Metrics app from the `AppRouterDelegate`.
9. In the `AppRouterDelegate` provide the `setInitialRoutePath` and the `setNewRoutePath` methods to handle the navigation and `build` method to build the `Navigator` widget with the configured list of pages. Also, override the `currentConfiguration` getter to help the `Router` in updating the route information.
10. With that in place we can use the provided methods from the `NavigationNotifier` to make navigation with the new navigation system.

The following sequence diagram displays the process of navigation with the new `Navigation 2.0`.

![Navigation](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/navigation2_design_docs/metrics/web/docs/features/navigator/diagrams/navigation_sequence_diagram.puml)

## Dependencies
> What is the project blocked on?

- The new navigation system requires Flutter to be of version `1.23.0` or higher.

## Results
> What was the outcome of the project?

The document designs an integration of the new navigation system into the Metrics Web Application and related changes.
