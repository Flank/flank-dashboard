# Router widget usage design

> Summary of the proposed change

Use the Router widget instead of Navigator on the Web App.

# References

> Link to supporting documentation, GitHub tickets, etc.
* [Learning Flutter’s new navigation and routing system](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade)

* [Router Class](https://api.flutter.dev/flutter/widgets/Router-class.html)

* [MaterialApp.router](https://api.flutter.dev/flutter/material/MaterialApp/MaterialApp.router.html)

* [Example](https://github.com/orestesgaolin/navigator_20_example/blob/master/lib/main_router.dart)

# Motivation

> What problem is this project solving?

Make UX more convenient.

# Goals

> Identify success metrics and measurable goals.

Correct behavior of the browser features as a forward button or the browser history.

# Non-Goals

> Identify what's not in scope.

The custom animation transition and the functionality of the existing observers are not in scope.

# Design

> Explain and diagram the technical design

## Metrics application

### Presentation layer

This layer contains the `MetricsRouteInformationParser` - the class that is used by the `Router` widget to parse route information into a configuration of type T.

Example:

``` class MetricsRouterInformationParser extends RouteInformationParser<String> {
      @override
      Future<String> parseRouteInformation(
          RouteInformation routeInformation) async {
        final uri = Uri.parse(routeInformation.location);
        final path = uri.pathSegments.first;
        if (path == RouteName.dashboard) return RouteName.dashboard;
      }
    
      @override
      RouteInformation restoreRouteInformation(String path) {
        if (path == RouteName.dashboard) {
          return const RouteInformation(location: RouteName.dashboard);
        }
      }
    }
 ```

Also, the `presentation` layer contains the `PageGenerator` class, similar to exist `RouteGenerator` class to encapsulate the logic of page creation.

Moreover, this layer contains the  `MetricsRouterDelegate` class - a delegate that is used by the `Router` widget to build and configure a navigating widget. 

The `build` method in a `MetricsRouterDelegate` needs to return a `Navigator`. In this way, our navigation changes will be reflected in the address bar.

The `onPopPage` callback uses `notifyListeners`. When the `MetricsRouterDelegate` notifies its listeners, the `Router` widget is likewise notified that the `MetricsRouterDelegate`'s `currentConfiguration` has changed and that it's the `build` method needs to be called again to build a new `Navigator`.

Example:
```
class MetricsRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final List<Page> _pages = [];
  final bool isLoggedIn;

  MetricsRouterDelegate({this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: _pages,
      onPopPage: (route, result) {
        if (!route.didPop(result) || !isLoggedIn) {
          return false;
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(String path) async {
    if (path == RouteName.dashboard) {
      _pages.add(
        PageGenerator.generatePage(
          name: RouteName.dashboard,
          isLoggedIn: isLoggedIn,
        ),
      );
    }
    notifyListeners();
    return;
  }
}


```

The structure of the presentation layer shown in the following diagram: 

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/router_widget/metrics/web/docs/features/router_widget/diagrams/router_widget_presentation.puml)

When the RouteInformationProvider emits a new route, it notifies the Router about changes.

Router delegates parsing of changes to the RouteInformationParser, which converts it into an abstract data type T.

RouterDelegate’s setNewRoutePath method is called with this data type and must update the application state to reflect the change and call notifyListeners.

When notifyListeners is called, it tells the Router to rebuild the RouterDelegate (using its build() method).

RouterDelegate.build() returns a new Navigator, whose pages now reflect the change to the app state.

The following sequence diagram shows the process of changing the route: 
![Route change diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/router_widget/metrics/web/docs/features/router_widget/diagrams/route_change_sequence.puml)

# Dependencies

> What is the project blocked on?

The router widget works correctly only on the flutter version `1.23` or higher.

# Results

> What was the outcome of the project?

Correct UX behavior allows the use forward arrow in the browser.
