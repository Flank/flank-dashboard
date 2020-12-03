# Navigator 2.0 and Router design

## TL;DR

Introducing Flutter’s new navigation and routing system into the Metrics Web Application allows us to make the application more comfortable in using and improve the user experience overall by solving such problems as back and forward navigation. 

# References

# References
> Link to supporting documentation, GitHub tickets, etc.
* [Learning Flutter’s new navigation and routing system](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade)
* [Router class](https://api.flutter.dev/flutter/widgets/Router-class.html)
* [`MaterialApp` with Router](https://api.flutter.dev/flutter/material/MaterialApp/MaterialApp.router.html)
* The [example](https://github.com/orestesgaolin/navigator_20_example/blob/master/lib/main_router.dart) of using Navigator 2.0

## Goals
> Identify success metrics and measurable goals.
* Browser back and forward navigation behaves as expected. 
* A clear design of the new navigation system integration.

## Design
> Explain and diagram the technical design

The following sections provide an implementation of a new navigation integration into the Metrics Web Application. As navigation is related to the UI of the application, the required changes affect only the presentation layer. Read more about layers and their responsibilities in the [Metrics Web Application architecture document](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/01_metrics_web_application_architecture.md). 

### Defining app routes

To define routes we will use the existing class with route names - `RouteName`.
In addition, we need to rework the `RouteGenerator` to a `PageGenerator`, which will have a static `generatePage` method with a `MaterialPage` return type.
To add a new route, you need to define its name in the `RouteName` class and add processing to the `PageGenerator.generatePage` method of that route.

### Parsing a route information
`MetricsRouteInformationParser` - the class that is used by the `Router` widget to parse route information into a configuration of type T. This class must extend the `RouteInformationParser` class.

Example:

``` 
class MetricsRouterInformationParser extends RouteInformationParser<String> {
      @override
      Future<String> parseRouteInformation(
          RouteInformation routeInformation) async {
        final uri = Uri.parse(routeInformation.location);
        final path = uri.pathSegments.first;
        if (path == RouteName.dashboard) return RouteName.dashboard;
      }
    }
 ```

### Creating a route delegate and routes state

`MetricsRouterDelegate` class - a delegate that is used by the `Router` widget to build and configure a navigating widget. 
The `build` method in a `MetricsRouterDelegate` needs to return a `Navigator`. In this way, our navigation changes will be reflected in the address bar.
To encapsulate the notifier logic, we'll create a `RoutePageManager` that takes care of changes the routes and holding page stack.
When the `RoutePageManager` notifies its listeners, the `Router` widget is likewise notified that the `MetricsRouterDelegate`'s `currentConfiguration` has changed and that it's the `build` method needs to be called again to build a new `Navigator`.

Example of build method:
```
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoutePageManager>.value(
      value: _pageManager,
      child: Consumer<RoutePageManager>(
        builder: (context, pageManager, child) {
          return Navigator(
            key: navigatorKey,
            onPopPage: _onPopPage,
            pages: List.of(pageManager.pages),
          );
        },
      ),
    );
  }
```

### Transition delegate
We will provide a custom implementation of `TransitionDelegate` to a `Navigator` that customizes how routes appear on (or are removed from) the screen when the list of pages changes.
By default, routes always have animation. We can use [NoAnimationTransitionDelegate](https://gist.githubusercontent.com/johnpryan/8bc65512d30c6b2350d841dfda007ec9/raw/27c6fc52e866ae6edad1bda18ca8e9cdb697d6c6/nav2_snippet17.dart) from [Learning Flutter’s new navigation and routing system](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade) guide to disable all animations.

**Important:** This class only affects the declarative API, so the back button still displays a transition animation.

### Making the app to use the Router class
First, we need to use `MaterialApp.router` instead of `MaterialApp` in the `main`.
There is no `observers` field in `MaterialApp.router`, we need to pass them directly to `Navigator` in the `MetricsRouterDelegate` class.
The existing observers remain unchanged. 

Second, we need to change all the `Navigator`'s methods in the existing code to use the `RoutePageManager` methods. 
For simple routing, we'll use the `setNewRoute` method. 
In case we need to clear the stack and push a single route, we can create methods such as `ClearStackAndPushDashboard` that will encapsulate the necessary logic.

### Making things work
The structure of the presentation layer shown in the following diagram: 

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/router_widget/metrics/web/docs/features/router_widget/diagrams/router_presentation_layer_class_diagram.puml)

When the `RouteInformationProvider` emits a new route, it notifies the `Router` about changes.

`Router` delegates parsing of changes to the `RouteInformationParser`, which converts it into an abstract data type T.

`RouterDelegate.setNewRoutePath` method is called with this data type and must update the application state to reflect the change and call `notifyListeners`.

When `notifyListeners` is called, it tells the `Router` to rebuild the `RouterDelegate` (using its build() method).

`RouterDelegate.build()` returns a new `Navigator`, whose pages now reflect the change to the app state.

The following sequence diagram shows the process of changing the route: 
![Route change diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/router_widget/metrics/web/docs/features/router_widget/diagrams/routing_sequence_diagram.puml)

## Dependencies
> What is the project blocked on?

- The new navigation system requires Flutter to be of version `1.23.0` or higher.

## Testing
> How will the project be tested?

Required changes in the following code for the tests to work properly with the new navigation system:
1. `MetricsThemedTestbed` class.
2. `BasePopup` tests.
3. `MetricsPageTitle` tests.
4. `MetricsUserMenuButton` tests.

## Results
> What was the outcome of the project?

The document designs an integration of the new navigation system into the Metrics Web Application and related changes.
