# Router widget usage design

Use the Router widget instead of Navigator on the Web App.

# References

[Router Class](https://api.flutter.dev/flutter/widgets/Router-class.html)

[MaterialApp.router](https://api.flutter.dev/flutter/material/MaterialApp/MaterialApp.router.html)

[Example](https://github.com/orestesgaolin/navigator_20_example/blob/master/lib/main_router.dart)

# Motivation

Make UX more convenient.

# Goals

Correct behavior of the browser features as a forward button or the browser history.

# Design

## Metrics application

### Presentation layer

This layer contains the `MetricsRouteInformationParser` - the class that is used by the `Router` widget to parse route information into a configuration of type T. 

Also, the `presentation` layer contains the `MetricsRouterDelegate` class - a delegate that is used by the `Router` widget to build and configure a navigating widget.
This delegate is the core piece of the `Router` widget. It responds to push route and pop route intents from the engine and notifies the `Router` to rebuild

Moreover, this layer contains the `RoutePageManager` class that encapsulate the page story mechanism and notify listeners when the page is changing. 

To introduce this feature, we should follow the next steps: 

1. Create a `MetricsRouteInformationParser` class.
2. Implement a `parseRouteInformation` method.
3. Implement a `restoreRouteInformation` method.
5. Create a `RoutePageManager` class 
6. Implement a `setNewRoutePath` method.
7. Create a `MetricsRouterDelegate` class.
8. Implement a `build` method.
9. Implement a `setNewRoutePath` method.
10. Integrate exist Observers to the `RoutePageManager` class.

The structure of the presentation layer shown in the following diagram: 

![Presentation layer diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/monorepo/raw/router_widget/metrics/web/docs/features/router_widget/diagrams/router_widget_presentation.puml)

# Dependencies

The router widget works correctly only on the flutter version `1.23` or higher.

# Results

Correct UX behavior allows the use forward arrow in the browser.
