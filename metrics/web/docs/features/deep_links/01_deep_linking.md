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
        - [Applying Deep Links](#applying-deep-links)
          - [PageParametersModel](#pageparametersmodel)
          - [PageParametersFactory](#pageparametersfactory)
          - [MetricsPage and MetricsPageFactory](#metricspage-and-metricspagefactory)
          - [NavigationNotifier](#navigationnotifier)
            - [Updating page parameters](#updating-page-parameters)
            - [Pop method changes](#pop-method-changes)
          - [PageNotifier](#pagenotifier)
        - [PageParametersProxy](#pageparametersproxy)
        - [Making things work](#making-things-work)
        - [Internal app navigation](#internal-app-navigation)
          - [Back Button navigation](#back-button-navigation)
          - [Deep linking with authorization](#deep-linking-with-authorization)

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
- Well-segregated responsibility between components;
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

#### Applying Deep Links
The following subsections describe the changes related to the following requirements:
- restore the application state from deep links parameters;
- update deep links in response to application events.

##### PageParametersModel
As we already know how the parse `query parameters`, we should introduce a new model that would represent the deserialized data from a query. For this purpose, we introduce a `PageParametersModel`.

The `PageParametersModel` is an interface for models that store the application state parameters parsed from the query parameters. This interface provides the `.toMap()` method that the application uses to serialize appropriate models to the query parameters `Map`. The implementers of the `PageParametersModel` should include the parameters that are specific to a `page` they relate to. Also, they should know how to serialize and deserialize their data using the `.toMap()` method and `.fromMap()` constructor respectively.

The following class diagram demonstrates the general approach for creating new `PageParametersModel`s on a `CoolPageParametersModel` example:

![PageParametersModel class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/deep_links_design_improvements/metrics/web/docs/features/deep_links/diagrams/page_parameters_model_class_diagram.puml)

##### PageParametersFactory
The concrete `PageParametersModel` stores the data for concrete pages and knows how to convert this data from/into query parameters. However, the application should decide what implementation of `PageParametersModel` to use for the current `RouteConfiguration`. The `PageParametersFactory` is to help here. This factory encapsulates the creation of specific `PageParametersModel` from the given `RouteConfiguration` calling the specific model deserialization.

Consider the following code snippet that demonstrates the `PageParametersFactory.create` method:
```dart
/// Returns the [PageParametersModel] based on the given [configuration].
PageParametersModel create(RouteConfiguration configuration) {
  final parameters = configuration.parameters;
  
  switch(configuration.name) {
    case RouteName.dashboard:
      return DashboardPageParameters.fromMap(parameters);
    case RouteName.projectGroups:
      // Other page parameters handling
  }
}
```

The `PageParametersFactory` should be injected into `NavigationNotifier` since the `NavigationNotifier` holds all the navigation-related logic of the application and controls its deep linking. Consider the [`NavigationNotifier`](#navigationnotifier) section to know more details in notifier-related changes.

##### MetricsPage and MetricsPageFactory
To make the application able to restore the `PageParametersModel` in response to navigation events (e.g., popping a page), we should update the `MetricsPage` and `MetricsPageFactory` classes.

A `MetricsPage` should store a `RouteName` that was used to create this page and the `PageParametersModel` as an `arguments` field. The `MetricsPage` class should also provide an overridden `copyWith` method to copy a page with the updated parameters.

We should also update the `MetricsPageFactory` to create `MetricsPage`s with the given `RouteName` and `PageParametersModel`.

The code snippet below demonstrates the `MetricsPageFactory.create` changes:
```dart
  /// Creates the [MetricsPage] from the given [RouteConfiguration].
  MetricsPage create({
    RouteName routeName, 
    PageParametersModel pageParameters,
  }) {
    switch (routeName) {
      case RouteName.loading:
        return MetricsPage(
          child: const LoadingPage(),
          routeName: routeName,
          arguments: pageParameters,
        );
    /// Other MetricsPages creation...
```

##### NavigationNotifier
The `NavigationNotifier` is a class that holds the navigation logic of the Metrics Web application. The following subsections describe the main changes to the`NavigationNotifier` related to the `deep linking` feature implementation.

###### Updating page parameters
When the `NavigationNotifier` receives a new `RouteConfiguration`, it should create a new `PageParametersModel` using a new `RouteConfiguration` instance and notify all listeners about the updates.

To do that, we should implement a new method `_updatePageParameters()` and call it whenever the current `RouteConfiguration` changes (in the `pop()` and the `_addNewPage()` methods).

The following diagram demonstrates the general concept for updating the `PageParametersModel` when the current `RouteConfiguration` changes:
![Updating page parameters diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/deep_links_design_improvements/metrics/web/docs/features/deep_links/diagrams/updating_page_parameters_sequence_diagram.puml)

###### Pop method changes
When the application pops a page, we should restore a `RouteConfiguration` from the new `MetricsPage` that precedes the popped one. To do that, let's implement a `MetricsPageRouteConfigurationFactory` that is responsible for creating a `RouteConfiguration` from the given `MetricsPage`.

The `MetricsPageRouteConfigurationFactory` is to be injected into the `NavigationNotifier`. The notifier uses it withing the `_getConfigurationFromPage` method as follows:
```dart
/// Creates a [RouteConfiguration] using the given [page].
RouteConfiguration _getConfigurationFromPage(MetricsPage page) {
  return metricsPageRouteConfigurationFactory.create(page);
}
```

##### Handling page parameters
The `NavigationNotifier` should also provide a method to handle the `PageParametersModel` updates reported from the application, for example, when a user applies a filter on a `DashboardPage`.

To handle the page parameters updates, we should implement a new `handlePageParametersUpdates()` method. This method triggers the following actions for the `NavigationNotifier`:
1. Update the current `RouteConfiguration`'s `RouteConfiguration.parameters`.
2. Update the current `PageParametersModel` with the given one.
3. Update the current page using the updated `RouteConfiguration` and the new `PageParametersModel`.
4. Update the current URL without changing the browser history using the `NavigationState` class.

##### PageNotifier
Updates to the `NavigationNotifier` class, allow us to introduce the `PageNotifier` abstract class that parents all the notifiers to be used as a `page` notifier. More precisely, for the pages that use `PageParametersModel`, their notifier should inherit the `PageNotifier` and provide an appropriate implementation.    

The `PageNotifier` abstracts the `handlePageParameters()` method that allows handling a new `PageParametersModel` exposed by the `NavigationNotifier`. The page-specific notifiers that extend the `PageNotifier` should provide the logic of applying the received `PageParametersModel`, and updating the `PageParametersModel` for the page.

Extending the `PageNotifier` is not mandatory for the page-specific notifiers. It is required only if the corresponding page uses the specific `PageParametersModel` and should expose parameters to the application URL.

#### PageParametersProxy
In the above sections, we discovered the required changes for the `NavigationNotifier` and examined the `PageNotifier` presenters with page-specific `PageParametersModel`s. However, the discovered changes lack the notes related to relationships between notifiers. More precisely, they don't review how to connect `NavigationNotifier` and `PageNotifier` but state that such a connection exists. Thus, let's talk about `PageParametersProxy`.

The `PageParametersProxy` is a widget that purposes to handle a connection between the `NavigationNotifier` and a specific `PageNotifier`. The proxy widget is responsible for the following:
- Subscribe to `NavigationNofier` and provide the latest `PageParametersModel` to the given `pageNotifier`;
- Subscribe to the given `pageNotifier` and send the `PageParametersModel` updates to the `NavigationNotifier`. 
  
The `PageParametersProxy` widget should wrap the whole page and be provided with a `PageNotifier` responsible for the underlying page's data.

The utilization of the `PageParametersProxy` is considered in the [next](#making-things-work) section.

#### Making things work
The following class diagram demonstrates the class structure for the deep linking feature:

![Deep links class diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/deep_links_design_improvements/metrics/web/docs/features/deep_links/diagrams/deep_links_class_diagram.puml)

Similarly, the following sequence diagrams explain the feature algorithms details:
- Applying deep links in the Metrics Web application:
  ![Applying deep links diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/deep_links_design_improvements/metrics/web/docs/features/deep_links/diagrams/applying_deep_links_sequence_diagram.puml)

- Updating deep links in response to the UI state changes:
  ![Saving deep links diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/deep_links_design_improvements/metrics/web/docs/features/deep_links/diagrams/updating_deep_links_sequence_diagram.puml)

#### Internal app navigation
This section describes the changes we should introduce to improve the overall navigation experience in the Metrics Web application.

##### Back Button navigation
Currently, the back button that is displayed on the `ProjectGroupPage` and on the `DebugMenuPage` navigates directly to the `DashboardPage`. However, this behavior can be unexpected to the user. Consider the following cases that may be confusing for the user:
- The user navigates to the `ProjectGroupPage` from the `DebugMenuPage`, and presses the `Back Button`. The application navigates the user to the `DashboardPage` instead of the `DebugMenuPage`;
- The user applies some filtering or sorting parameters on the `DashboardPage`, navigates to the `ProjectGroupPage`, and presses the `Back Button`. The application navigates the user to the `DashboardPage`, however, does not restore the page parameters.

To improve the navigation experience here, we should introduce a new method to the `NavigationNotifier` - `canPop()`, that returns `true` if the current page can be popped.

Now, when the `back button` is pressed, we should perform the following:
1. Pop the current page if the `NavigationNotifier.canPop` returns `true`;
2. If there is no underlying page, push and replace the current page with the `DashboardPage`.

Using such an approach allows users to navigate directly to the previous page if it exists, and to restore the applied `PageParametersModel` to the previous page if any.

##### Deep linking with authorization
Currently, the application pushes the `DashboardPage` when the user logs in, however, it would be much more user-friendly if the application redirects the user to the requested resource.

To improve this aspect of the navigation, we should modify the existing redirecting behaviour:
1. Use the `_redirectRoute` field to stores the redirect `RouteConfiguration` that requires authorization.
2. When the application pushes a new route that requires authorization, and the user is unauthenticated, set the `_redirectRoute`. If the route does not require authorization, clear the `_redirectRoute`.
3. When the user logs in, redirect the user to the `_redirectRoute` and clear the `_redirectRoute`.

To implement such a behaviour, we should split the `.handleAuthenticationUpdates()` method of the `NavigationNotifier` into two different methods: `.handleLogOut()` and `.handleLogIn()`.

The `.handleLogOut()` should redirect the user to the `LoginPage`, and the `.handleLogIn()` should redirect the user to the `_redirectRoute`, or to the `DashboardPage` if the `_redirectRoute` is `null`.

Consider the following sequence diagram that describes handling deep links that require authorization:
  ![Saving deep links diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/deep_links_design_improvements/metrics/web/docs/features/deep_links/diagrams/deep_links_and_authorization_sequence_diagram.puml)
