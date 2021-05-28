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

Consider the following classes, that represent the architecture of the `Navigator 2.0`.

### Router

The `Router` is a class, that listens for routing information from the operating system (e.g. browser), parses that information using the [RouteInformationParser](#route-information-parser) into the user-defined configuration ([RouteConfiguration](#route-configuration)), and then [RouterDelegate](#router-delegate) uses configuration to build the `Navigator` widget with a list of pages.

Consider the following parts of the `Router` class:

 - a [Route Information Provider](#route-information-provider) listens to the events from the operating system and sends events back to the operating system when the app state changes;
 - a [Route Information Parser](#route-information-parser) parses route information into the user-defined configuration and vice versa;
 - a [Router Delegate](#router-delegate) takes configuration from the `RouteInformationParser` and builds a list of pages.

### Route Information Provider

A `RouteInformationProvider` is a class that provides a [RouteInformation](#route-information) from operating system to the [RouteInformationParser](#route-information-parser). Generally speaking, this class is a "bridge" between the browser (or the OS) and the `Router` class.

When a user enters a URL in the browser, the `RouteInformationProvider` converts the URL into the [RouteInformation](#route-information) class instance and provides a result to the [RouteInformationParser](#route-information-parser). Similarly, when the application changes its state, the `RouteInformationProvider` receives the updated [RouteInformation](#route-information) and provides this change to the browser to make reflecting changes (e.g. update URL in the browser).

The Flutter framework provides the default `RouteInformationProvider` implementation, so there is no need to implement it for the `Metrics Web Application`.

### Route Information

A `RouteInformation` is a class that contains a `location` string of the application and a `state` object that configures the application in this `location`. More precisely:
- a `location` is multiple string identifiers with slashes in between (for example, '/path/to/page'). For the web application, the location represents a URL.
- a `state` is an object that stores data in the browser history entry (filled form inputs, scroll position, etc.).

### Route Information Parser

The `RouteInformationParser` is a class that acts in two directions:
 - parses incoming [RouteInformation](#route-information) obtained from the [RouteInformationProvider](#route-information-provider) into the user-defined [RouteConfiguration](#route-configuration);
 - creates a new [RouteInformation](#route-information) object from the [RouteConfiguration](#route-configuration) and to pass it back to the [RouteInformationProvider](#route-information-provider).

To handle our specific routes, we should define `MetricsRouteInformationParser` for the Metrics Web Application. This parser is to implement the `RouteInformationParser` and provide two methods:

```dart
class MetricsRouteInformationParser implements RouteInformationParser<RouteConfiguration> {
    @override
    Future<RouteConfiguration> parseRouteInformation(RouteInformation routeInformation);

    @override
    RouteInformation restoreRouteInformation(RouteConfiguration configuration);
}
```

The `parseRouteInformation` method converts the [RouteInformation](#route-information) into the [RouteConfiguration](#route-configuration) to pass this configuration to the [RouterDelegate](#router-delegate) class. Similarly, the `restoreRouteInformation` method converts the [RouteConfiguration](#route-configuration) back into the [RouteInformation](#route-information). These methods exist to keep the URL in the browser's location bar up to date with the application state, allowing it's back and forward buttons to function as a user expects.

To simplify parsing route information we introduce the [`RouteConfigurationFactory`](#route-configuration-factory). This class can create a [`RouteConfiguration`](#route-configuration) instance using the given [`RouteInformation`](#route-information).

### Route Configuration

The `RouteConfiguration` is a class that holds the data that describes the route. It contains the route name, URL path, and information about the authentication status this route requires.

### Router Delegate

A `RouterDelegate` class is used to build the `Navigator` with a list of configured pages. It defines how the `Router` reacts to changes in both the application state and operating system.

This is a core part of the `Router` and it is responsible for:
 - reacting to push and pop route intents;
 - notifying the `Router` to rebuild;
 - acting as a builder for the `Router` that builds the `Navigator` widget.

To specify the app-specific behavior we should extend the `RouterDelegate` with `ChangeNotifier` and `PopupNavigatorRouterDelegateMixin` mixins (both simplify delegate implementation). Also, we must provide the following methods:

```dart
class MetricsRouterDelegate extends RouterDelegate<RouteConfiguration> 
with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfiguration> {
    @override
    RouteConfiguration get currentConfiguration;

    @override
    Widget build(BuildContext context);

    @override
    Future<void> setInitialRoutePath(RouteConfiguration routeConfiguration);

    @override
    Future<void> setNewRoutePath(RouteConfiguration routeConfiguration);
}
```

Let's take a closer look at the `MetricsRouterDelegate` members:
- The `currentConfiguration` is a value that `Router` uses to populate the browser history to support the back and forward buttons in the browser top bar.
- The `setInitialRoutePath` method is called at startup with the [RouteConfiguration](#route-configuration) of the initial route.
- The `setNewRoutePath` method is called when the [Route Information Provider](#route-information-provider) reports that the operating system pushes a new route to the application. This method takes the [RouteConfiguration](#route-configuration) that comes from the [Route Information Parser](#route-information-parser) and changes the list of pages accordingly.
- The `build` method builds the `Navigator` widget with the current list of pages.

A [`NavigationNotifier`](#navigation-notifier) simplifies routes managing and should be injected into the `Router Delegate`. The delegate then subscribes to the navigation notifier state. When this state changes, the router rebuilds. Consider the following code:

```dart
class MetricsRouterDelegate extends RouterDelegate<RouteConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfiguration> {
  final NavigationNotifier navigationNotifier;

  MetricsRouterDelegate({
    this.navigationNotifier,
  }) {
    navigationNotifier.addListener(notifyListeners);
  }
```

### Navigation Notifier

A `NavigationNotifier` is a `ChangeNotifier` that manages a list of current pages of the application and provides methods to perform navigation. Also, this class holds information about an authentication state of the current user to restrict visiting specific pages that require a user to be logged in.

The `NavigationNotifier` requires two classes to be injected:
 - [Metrics Pages Factory](#metrics-page-factory)
 - [Route Configuration Factory](#route-configuration-factory)

The `NavigationNotifier` provides several navigation methods that are similar to methods the `Navigator` widget provides. But unlike the `Navigator` methods, the ones of `NavigationNotifier` do not return a `Future`. The main reason is that the [Metrics Web presentation layer architecture](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/02_presentation_layer_architecture.md) declares the interactions between pages and the UI logic to be in a presenter (`ChangeNotifier`, in our case) and performed using `View Models`. Thus, the following statements hold:
- using the `MetricsPage` data directly in the UI (for example, in a page widget) or adding such logic to the widget itself - breaks the principle of separation between the presentation layer components and complexifies testing;
- implementing the data flow (using `View Model`s) between pages/widgets using the result param of the `.pop()` method - breaks the principle of separation between the presentation layer components and complexifies testing.

According to the above, we **do not** pass parameters using internal navigation and **do not** implement similar logic for the new navigation system within the Metrics Web Application.

To be sure that the application will work correctly, we should ensure that all of its components, such as `Feature Config` or `Local Config` initialized before the user gets access to the application. Thus, the application must show the `Loading Page` when the initialization is in progress. Once the initialization process finishes, the application should redirect the user to the route user tried to open.

Consider the following sequence diagram that will describe this process in more details:

![Not Initialized App Navigation Sequence Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/navigation/diagrams/not_initialized_app_navigation_sequence_diagram.puml)

### Metrics Page Factory

The `MetricsPagesFactory` is a class that is responsible for creating a new [MetricsPage](#metrics-page) by the given `RouteConfiguration`. If the given `RouteConfiguration` matches with one of the predefined configurations, the factory creates a new `MetricsPage` to add it then to the current pages.

### Metrics Page

The `MetricsPage` is an app-specific implementation for the `Page` class that holds a configuration for the `Route`. The `MetricsPage` creates the `MetricsPageRoute` that disables transition animation on route changes.

The `NavigationNotifier` holds and manages the list of current `MetricsPage`s to use them in the `Navigator` constructor within the `MetricsRouterDelegate`.

### Route Configuration Factory

The `RouteConfigurationFactory` is responsible for creating the [RouteConfiguration](#route-information) from the given `URI`. In fact, it uses the `MetricsRoutes` class that holds a list of pre-defined `RouteConfiguration`s and maps the incoming URI to the `RouteConfiguration` related to the specific application page that matches the given `URI`.

The following diagram describes the structure and relationship between the above classes:

![Route change diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/navigation/diagrams/navigation_class_diagram.puml)

## Making things work

The following section provides implementation details of a new navigation system for the Metrics Web Application. As navigation is related to the UI of the application, the required changes affect only the presentation layer. Read more about layers and their responsibilities in the [Metrics Web Application architecture document](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md).

According to the above class diagram, we should implement several classes to integrate the Router class into the application. Here is a list of them providing a short description for each class: 
- `MetricsRouteInformationParser` as the app-specific [`RouteInformationParser`](#route-information-parser) with the `RouteConfigurationFactory` to simplify parsing.
- `MetricsRouterDelegate`as the app-specific [`RouterDelegate`](#router-delegate).
- `NavigationNotifier` to manage pages and rebuild the `Navigator`.
- `MetricsPageFactory` to simplify creating pages within the `NavigationNotifier`.

Once the required classes are implemented and ready to use, we can migrate the application to the new navigation. In the `MetricsApp` we should replace the `MaterialApp` constructor with the `MaterialApp.router()` and inject the required fields. Follow the design examined in the class diagram to integrate all implemented classes. After all classes are in place and configured, the new navigation is integrated!

The following sequence diagrams describe the navigation process using the new `Navigation 2.0` integrated.

Navigation using the browser history or the browser URL bar:

![Navigation](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/navigation/diagrams/external_navigation_sequence_diagram.puml)

Navigation using the application API:

![Navigation 2](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/Flank/flank-dashboard/raw/master/metrics/web/docs/features/navigation/diagrams/internal_navigation_sequence_diagram.puml)

## Dependencies
> What is the project blocked on?

- The new navigation system requires Flutter to be of version `1.23.0` or higher.

## Testing
> How the existing test codebase is affected by the changes with Router class

The Metrics Web Application tests require additional changes to work properly with the new navigation system:
- create `MetricsMaterialAppTestbed` and replace `MaterialApp` with this testbed in places where tests require navigation;
- update the `MetricsThemedTestbed` class and test cases that use this testbed and its navigation;
- inject the `NavigationNotifier` into the `TestInjectionContainer` and update tests that require `NavigationNotifier`.

## Results
> What was the outcome of the project?

The documented designs of the integration of the new navigation system into the Metrics Web Application and related changes.
