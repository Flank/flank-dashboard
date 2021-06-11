# Deep Linking
> Feature description / User story.

As a user, I want to pass direct links to project and/or project groups, so that other users can navigate easier.

## Contents

- [**Analysis**](#analysis)
    - [Feasibility study](#feasibility-study)
    - [Requirements](#requirements)
    - [Prerequisites](#prerequisites)
    - [Landscape](#landscape)
      - [3-rd party packages approach](#3-rd-party-packages-approach)
      - [Custom implementation approach](#custom-implementation)
    - [Prototyping](#prototyping)
      - [Getting the `query parameters` from the URL](#getting-the-query-parameters-from-the-url)
      - [Updating the URL and the query parameters](#updating-the-url-with-the-query-parameters)
    - [System modeling](#system-modeling)
- [**Design**](#design)
    - [Architecture](#architecture)
      - [`NavigationNotifier` approach](#navigationnotifier-approach)
      - [Route parameters approach](#route-parameters-approach)
    - [Program](#program)
        - [Parsing Deep Links](#parsing-deep-links)
          - [RouteConfiguration](#routeconfiguration)
          - [RouteConfigurationFactory](#routeconfigurationfactory)
          - [RouteInformationParser](#routeinformationparser)
          - [Parsing Deep Links Summary](#parsing-deep-links-summary)

# Analysis
> Describe the general analysis approach.

The `Deep Linking` feature improves the navigation experience by allowing users to navigate to a specific resource of an application and to save the application state in a URL.

The analysis stage aims the following goals:
1. Define the detailed requirements for the deep linking feature;
2. Investigate existing approaches for the deep linking in the Flutter Web applications.
3. Define which approach satisfies our requirements: existing external solutions, or the custom-developed approach.

### Feasibility study
> A preliminary study of the feasibility of implementing this feature.

The `Deep Linking` feature improves the overall user experience in terms of navigation, so this feature makes sense for the project.

To implement the `Deep Linking` feature, we should be able to perform the following actions:
- Parsing the `query parameters` from the URL;
- Possibility to update the URL and the query parameters without changing the current browser history;

Since `Navigator 2.0` provides the navigation system that allows performing the actions listed above, and the Metrics Web application uses `Navigator 2.0`, it is possible to implement the `Deep Linking` feature in the Metrics Web application.

### Requirements
> Define requirements and make sure that they are complete.

The `Deep Linking` feature must satisfy the following requirements:
- Possibility to handle deep links and restore the application's state using them;
- Possibility to update the URL and the query parameters without changing the current browser history;
- Possibility to restore deep links/application state in response to app-specific events (`back`, `home` button pressed, etc.);

### Prerequisites
Before deep-diving into deep linking feature analysis, make sure to get familiar with the Flutter new navigation system ([Navigator 2.0](https://flutter.dev/docs/release/breaking-changes/route-navigator-refactoring)) which is [used in the Metrics Web application](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/navigation/01_navigation_design.md). The understanding of the Navigator 2.0 approach is important for understanding deep linking approaches.

### Landscape
> Look for existing solutions in the area.

There are 2 main approaches for implementing the `Deep Linking` feature in the Metrics Web application:
- [3-rd party packages](#3-rd-party-packages-approach);
- [A custom implementation](#custom-implementation).

Let's compare the listed approaches in a bit more detail.

#### 3-rd party packages approach
This approach means the utilization of the 3-rd party packages, such as [`routemaster`](https://pub.dev/packages/routemaster), [`beamer`](https://pub.dev/packages/beamer), [`auto_route`](https://pub.dev/packages/auto_route), etc.

All the listed packages wrap the Flutter's `Navigator 2.0` and provide a simple API to work with. However, to integrate such a package into the Metrics Web application, we must use the `RouteInformationParser` and `RouterDelegate` the package provides.

Consider the following code snippet that demonstrates the integration of the [`routemaster`](https://pub.dev/packages/routemaster) package to the Flutter applications.

```dart
void main() {
  runApp(
      MaterialApp.router(
        routerDelegate: RoutemasterDelegate(routesBuilder: (context) => routes),
        routeInformationParser: RoutemasterParser(),
      ),
  );
}
```

In general, the 3-rd party libraries listed above use the following approaches for handling `query parameters`:
- Accessing the current configuration with a `Map` of `query parameters` (e.g., [`beamer`](https://pub.dev/packages/beamer#quick-start), [`routemaster`](https://pub.dev/packages/routemaster#features));
- Automatic handling using annotations and code generation (e.g., [`auto_route`](https://pub.dev/packages/auto_route#working-with-paths)).

The listed 3-rd party libraries don't provide an ability to update the URL without changing the current history.

Let's sum up the pros and cons of using 3-rd party libraries:

Pros:
- Provides ready-to-use implementation out of the box, including deep linking, nested navigation, and many other features.

Cons:
- May require code generation (e.g., as in [`auto_route`](https://pub.dev/packages/auto_route) package);
- Requires the navigation system reintegration - meaning that we must use the 3-rd party `RouteInformationParser`s and `RouterDelegate`s.
- Does not provide a way to replace the current URL value without changing the browser history.

#### Custom implementation
This approach means the `Deep Linking` implementation using the `Navigator 2.0` features, which is already integrated into the Metrics Web application. 

Consider the following pros and cons of the custom implementation approach:

Pros:
- Highly customizable approach;
- Well-testable approach;

Cons:
- Requires more code comparing to the 3-rd party package approach.

According to the comparison above, we choose the [`Custom implementation`](#custom-implementation) approach, as it fits the current navigation approach used in the Metrics Web application, and satisfies the customization and testability requirements.

Consider this diagram that briefly describes the custom implementation approach:

![Custom approach diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/features/deep_links/diagrams/custom_approach_component_diagram.puml)

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

As we've described in the [`requirements`](#requirements) section, we must be able to perform the following actions to implement the `Deep Linking` feature:
- [Getting the `query parameters` from the URL](#getting-the-query-parameters-from-the-url);
- [Updating the URL and the query parameters without changing the current browser history](#updating-the-url-with-the-query-parameters);

The next code snippets demonstrate how we can perform the listed required actions:

#### Getting the query parameters from the URL

Since `Navigator 2.0` provides a `RouteInformationParser` class that gives access to the URL, we can parse the `query parameters` from the URL.

Consider the following code snippet showing the process of getting the query parameters from the `RouteConfiguration` provided by the Flutter Navigator:
```dart
T parseRouteInformation(RouteInformation routeInformation) {
  final location = routeInformation.location;
  
  print(location); // page?queryParameter=someParameter
  
  final uri = Uri.parse(location);

  print(uri.queryParameters); // {queryParameter : someParameter}
}
```

#### Updating the URL with the query parameters
The following code snippet demonstrates the process of updating the URL and the query parameters without changing the current browser history (using the [`universal_html`](https://pub.dev/packages/universal_html) package):
```dart
import 'package:universal_html/universal_html.dart' show window;

final history = window.history;

final path = '/page';
final queryParameters = {
  'queryParameter' : 'someParameter',
};
final uri = Uri(path: path, queryParameters: queryParameters);

print('$uri'); // /page?queryParameter=someParameter

history.replaceState(null, 'metrics', '$uri'); 
```

### System modeling
> Create an abstract model of the system/feature.

The `Deep Linking` feature implementation mostly includes the modification of existing components of the navigation system used in the Metrics Web application. Consider the following component diagram that demonstrates this:

![Deep links integration diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/features/deep_links/diagrams/deep_links_integration_component_diagram.puml)

# Design
Let's review the implementation details in the next subsections.

### Architecture
> Fundamental structures of the feature and context (diagram).

There are two possible architecture approaches of the `Deep Linking` feature integration to the Metrics Web application:
- [`NavigationNotifier`](#navigationnotifier-approach) approach;
- [`Route Parameters`](#route-parameters-approach) approach.

In general, the listed approaches have the same `query parameters` parsing algorithm, which is considered in the next sections. However, the `NavigationNotifier` and the `Route Parameters` approaches differ in the following aspects:
- How the application applies the deep links (for example, how the Metrics Web application restores its state from a deep link);
- How the application updates the URL and the query parameters without changing the browser history.

Let's compare the listed approaches.

#### `NavigationNotifier` approach
The `NavigationNotifier` is a `ChangeNotifier` that holds the navigation logic of the Metrics Web application. 

The `Page ChangeNotifiers` are `ChangeNotifier`s that are responsible for providing the data to display to specific `Page`s. For example, the `ProjectMetricsNotifier` provides the data to the `DashboardPage`, and the `ProjectGroupsNotifier` provides the data to the `ProjectGroupPage`.

So, the main idea of this approach is to create a bidirectional connection between the `NavigationNotifier` and the `Page ChangeNotifiers`, which allows to:
- Provide the page parameters updates to `Page ChangeNotifiers`, which apply them (e.g., apply filtering criteria, searching values, etc.);
- Provide the page parameters updates to `NavigationNotifier` (e.g., when the user applies a filter, searches, etc.), which updates the URL and the browser history.

Consider the following component diagram that briefly describes this approach:

![Navigation notifier approach diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/features/deep_links/diagrams/navigation_notifier_approach_component_diagram.puml)

Let's sum up the pros and cons of this approach:

Pros:
- Well segregated responsibility between components;
- Extensible approach - meaning that we can easily add new page-specific deep links or extend them;
- Well-testable because of the responsibility segregation.

Cons:
- Requires extending the existing `ChangeNotifier`s.

#### Route Parameters approach
The main idea of this approach is to pass the deep links directly to the specific pages that will handle them. When the page parameters change (e.g., in response to sorting, filtering, etc.), the pages use the `NavigationNotifier` to update the URL and the query parameters without changing the browser history.

Consider the next component diagram that illustrates this approach:

![Route parameters approach diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/features/deep_links/diagrams/route_parameters_approach_component_diagram.puml)

Let's review the pros and cons of the `route parameters` approach:

Pros:
- Does not require implementing new or extending existing `ChangeNotifier`s.

Cons:
- Does not satisfy the existing architecture requirements (see this [section](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/02_presentation_layer_architecture.md#ui-elements) of the ["Metrics Web Presentation Layer"](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/02_presentation_layer_architecture.md) document); 
- Less testable;
- High coupling;
- Adding parameters handling may increase the page widgets size, and decrease the code readability.

Comparing the approaches described above, we choose the [`NavigationNotifier`](#navigationnotifier-approach) approach as it aligns with the overall architectural requirements, simplifies the testing process, and is highly extensible.

### Program
> Detailed solution description to class/method level.

Once we've chosen the desired implementation approach, let's review the required changes needed to implement the `Deep Linking` in the Metrics Web application.

First, we should be able to parse the `query parameters` from the URL and update the URL with the `query parameters`. When we're able to do that, we should create a unified mechanism to apply the deep links in the Metrics Web application.

Consider the following subsections that describe each point:
- [Parsing the deep links](#parsing-deep-links).

#### Parsing Deep Links
The following subsections describe the required changes we should implement to be able to parse the deep links in the Metrics Web application:
- [RouteConfiguration](#routeconfiguration)
- [RouteConfigurationFactory](#routeconfigurationfactory)
- [RouteInformationParser](#routeinformationparser)

##### RouteConfiguration
The `RouteConfiguration` is a class that holds the information describing a specific route in the Metrics Web application. 

Currently, the `RouteConfiguration` holds the following fields:
- `name` - a name of a route;
- `path` - a full path of the route (excluding query parameters);
- `isAuthorizationRequired` - a flag that indicates whether the route requires the authorization. 
  
To be able to handle the deep links represented as the `query parameters` of the given URL, we should extend the `RouteConfiguration` model by adding a `parameters: Map<String, dynamic>` field to it. We should also update the helper methods, such as `props` and `copyWith`.

##### RouteConfigurationFactory
The `RouteConfigurationFactory` is a class responsible for creating a `RouteConfiguration` from the given `Uri`. Consider this factory's `create` method code:
```dart
RouteConfiguration create(Uri uri) {
  final pathSegments = uri?.pathSegments;

  if (pathSegments == null || pathSegments.isEmpty) {
    return MetricsRoutes.loading;
  }

  final routeName = pathSegments.first;

  if (routeName == RouteName.login.value) {
    return MetricsRoutes.login;
  } else if (routeName == RouteName.dashboard.value) {
    return MetricsRoutes.dashboard;
  } else if (routeName == RouteName.projectGroups.value) {
    return MetricsRoutes.projectGroups;
  } else if (routeName == RouteName.debugMenu.value) {
    return MetricsRoutes.debugMenu;
  }

  return MetricsRoutes.dashboard;
}
```

To be able to create a specific route with the `query parameters`, we should modify the `RouteConfiguration` class to provide named constructors for routes used in the Metrics Web application and make the default constructor private. After the described changes, we should reuse the created named constructors in the `RouteConfigurationFactory` instead of the `MetricsRoutes` class.

Consider the following code snippet that demonstrates this:
```dart

class RouteConfiguration {
  /// A name of this route.
  final RouteName name;

  /// A path of this route that is used to create the application URL.
  final String path;

  /// A flag that indicates whether the authorization is required for this route.
  final bool authorizationRequired;

  /// A parameters of this route that is used to create the application URL.
  final Map<String, dynamic> parameters;

  const RouteConfiguration._({
    @required this.name,
    @required this.authorizationRequired,
    this.path,
    this.parameters,
  })  : assert(name != null),
        assert(authorizationRequired != null);
  
  const RouteConfiguration.dashboard({
    Map<String, dynamic> parameters,  
  }) : super(name: RouteName.dashboard, 
             authorizationRequired: true, 
             path: '${RouteName.dashboard}',
             parameters: parameters,
            );
  
  /// Other named constructors...
}

class RouteConfigurationFactory {
  RouteConfiguration create(Uri uri) {
    final pathSegments = uri?.pathSegments;

    if (pathSegments == null || pathSegments.isEmpty) {
      return RouteConfiguration.loading();
    }

    final routeName = pathSegments.first;
    final queryParameters = uri?.queryParameters;

    if (routeName == RouteName.login.value) {
      return RouteConfiguration.login(parameters: queryParameters);
    } else if (routeName == RouteName.dashboard.value) {
      return RouteConfiguration.dashboard(parameters: queryParameters);
    } else if (routeName == RouteName.projectGroups.value) {
      return RouteConfiguration.projectGroups(parameters: queryParameters);
    } else if (routeName == RouteName.debugMenu.value) {
      return RouteConfiguration.debugMenu(parameters: queryParameters);
    }

    return RouteConfiguration.dashboard();
  }
}
```

##### RouteInformationParser
The `Navigator 2.0` integration uses the `RouteConfiguration` to restore the URLs when the navigation state changes (e.g., when the user opens or closes a page). This restoration takes place in the `MetricsRouteInformationParser.restoreRouteInformation()` method. Consider this method's code:
```dart
@override
RouteInformation restoreRouteInformation(RouteConfiguration configuration) {
  if (configuration == null) return null;

  return RouteInformation(location: configuration.path);
}
```

As we can see, the current implementation does not restore the `query parameters` of a URL, but only the URL's `path`. 

To restore the `RouteInformation` correctly, we should implement a `RouteConfigurationLocationConverter` class with a `.convert()` method that converts the given `RouteConfiguration` instance to a location `String`.
```dart
class RouteConfigurationLocationConverter {
  /// Converts the given [configuration] to a location [String].
  String convert(RouteConfiguration configuration) {
    final path = configuration.path;
    final parameters = configuration.parameters;

    /// We need to perform this because:
    /// Uri(path: 'foo', queryParameters: {}) => '/foo?' instead of '/foo'
    /// Uri(path: 'foo', queryParameters: null) => '/foo'
    final queryParameters = parameters.isNotEmpty ? parameters : null;
    
    final uri = Uri(path: path, queryParameters: queryParameters);
    return '$uri';
  }
}
```

When we've implemented the `RouteConfigurationLocationConverter` class, we can use it in the `MetricsRouteInformationParser.restoreRouteInformation()` method as the following:
```dart
class MetricsRouteInformationParser {
  final RouteConfigurationLocationConverter _locationConverter;
  
  // Upper fields constructors..

  @override
  RouteInformation restoreRouteInformation(RouteConfiguration configuration) {
    if (configuration == null) return null;

    final location = _locationConverter.convert(configuration);

    return RouteInformation(location: location);
  }
}
```

##### Parsing Deep Links Summary
Consider this class diagram that illustrates the required changes needed to parse the deep links from the URL:

![Parsing deep links diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/master/metrics/web/docs/features/deep_links/diagrams/parsing_deep_links_class_diagram.puml)
