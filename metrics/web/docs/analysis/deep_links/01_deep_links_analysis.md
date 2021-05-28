# Deep Links Approaches Analysis
> Feature description / User story.

As a user, I want to pass direct links to project and/or project groups, so that other users can navigate easier.

# Analysis
> Describe the general analysis approach.

During the analysis stage, we are going to investigate the implementation approaches for deep linking in Flutter Web applications and choose the most suitable one for the Metrics Web application.

## Feasibility study
> A preliminary study of the feasibility of implementing this feature.

Since the Flutter [supports deep links](https://flutter.dev/docs/development/ui/navigation/deep-linking) and provides a new navigation system (Navigator 2.0) which is used in the Metrics Web application, we can implement the deep linking in the Metrics Web application.

## Requirements
> Define requirements and make sure that they are complete.

The deep links implementation approach that we are to select must satisfy the following requirements:
- Possibility to handle deep links and restore the application's state using them;
- Possibility to save the application's state in deep links as a response to UI events (e.g. filtering, dropdown selections, searching, etc.);
- Extensible and testable implementation approach.

## Landscape
> Look for existing solutions in the area.

We need to decide with the approaches for the following concepts:
- [Deep Linking Approach](#deep-linking-approach) - meaning how the application's state is represented in the URLs.
- [Deep Links Integration Approach](#deep-links-integration-approach) - meaning how the Metrics Web Application handles deep links.

Let's review these approaches in the next sections.

### Deep Linking approach
There are two main ways of representing deep links in the URL: 
- [Query parameters](#query-parameters);
- [Path segments](#path-segments).   

To start, let's consider a problem that we are to solve using deep links. For example, we need to save a project name filter's state in a URL. Let's compare the listed approaches for solving this problem:

### Query Parameters
Using query parameters, the deep link may look like the following:
`https://metrics.web.app/dashboard?project_name=web_app`

Usually, query parameters are used to represent some filtering and grouping criteria. Such an approach allows combining several searching, filtering, and grouping parameters simultaneously.

#### Pros
- Dart provides a perfect API for parsing query parameters. Consider the following code snippet that demonstrates how to parse query parameters in Dart:
```dart
final url = Uri.parse("https://domain.com?foo=bar&bar=baz&array=q&array=w");

print(url.query); // foo=bar&bar=baz&array=q&array=w
print(url.queryParameters); // {foo: bar, bar: baz, array: w}
print(url.queryParametersAll); // {foo: [bar], bar: [baz], array: [q, w]}
```

- Query parameters are flexible - meaning that we can combine multiple searching, filtering, or grouping criteria.

#### Cons
- Query parameters may be less readable comparing to the path segments approach.

### Path segments
Using path segments, the deep link may look like the following:
`https://metrics.web.app/dashboard/project_name/web_app`

Path segments are usually used to identify a specific resource. They may be more readable to users, however, they are less flexible in terms of combining multiple searching, filtering, or grouping parameters.

#### Pros
- Path segments may be more readable to users.

#### Cons
- As the path segments of the URL are order-sensitive, the parsing is much more complicated, comparing to the query parameters. The following code snippet demonstrates the URL path segments parsing in Dart:
```dart
final url = Uri.parse("https://domain.com/foo/bar/baz");

print(url.pathSegments); // [foo, bar, baz]
```
- Less flexible approach - meaning that it is hard to combine multiple searching, filtering, or grouping arguments.

### Conclusion
According to the [requirements](#requirements) listed above, and the comparison of the [`query parameters`](#query-parameters) and the [`path segments`](#path-segments), we choose to use the [`query parameters`](#query-parameters) approach for deep linking.

### Deep Links Integration Approach
There are two main approaches for the integration of the deep links to the Metrics Web Application:
- [Deep Links Integration Using ChangeNotifier](#deep-links-integration-using-changenotifier).
- [Deep Links Integration Using Route Parameters](#deep-links-integration-using-route-parameters).

Note, as the Metrics Web Application uses `Navigator 2.0` (consider this [document](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/navigation/01_navigation_design.md) describing `Navigator 2.0` integration in the Metrics Web Application) for navigation, both approaches are based on the features of the `Navigator 2.0` and differ only in the way the deep links are applied to the Metrics Web Application components.

Now, let's review the listed approaches in a bit more detail.

### Deep Links Integration Using ChangeNotifier
The main idea of this approach is to introduce a new `ChangeNotifier`, let's call it a `DeepLinksNotifier`. 

__Note: the naming is a work in progress and may be changed during the `Design` phase.__

The `DeepLinksNotifier` is responsible for:
- Processing raw deep links provided by the `NavigationNotifier` into page-specific deep links Dart objects;
- Providing page-specific deep links to the corresponding page `ChangeNotifier`s to handle them;
- Handling page-specific deep links updates provided by page `ChangeNotifier`s;
- Providing deep link updates to the `NavigationNotifier`, which updates the browser history state to save a deep link update in a URL.

#### Pros
- Well segregated responsibility between components;
- Extensible approach - meaning that we can easily add new page-specific deep links or extend them;
- Easy to test, because of the responsibility segregation.

#### Cons
- Requires implementing new `ChangeNotifier`s and extending existing ones.

### Deep Links Integration Using Route Parameters
The main idea of this approach is to dispatch deep links using page parameters, which are then handled by the pages. For example, if a `DashboardPage` includes a project group selection menu, we can add a `projectGroupName` parameter to a `DashboardPage`, which is then handled by the page itself.

However, according to the ["UI elements"](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/02_presentation_layer_architecture.md#ui-elements) section of the ["Metrics Web Presentation Layer"](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/02_presentation_layer_architecture.md) document, a `Page` is a widget, whose responsibility is a proper Metrics widgets combining, thus, handling any parameters is out of scope of the `Page`'s responsibilities.

#### Pros
- Does not require implementing new or extending existing `ChangeNotifier`s.

#### Cons
- Does not satisfy the existing architecture requirements;
- Harder to test;
- Adding parameters handling may increase the `page` widgets size, and decrease the code readability.

### Conclusion
According to the comparison above, we choose the [Deep Links Integration Using ChangeNotifier](#deep-links-integration-using-changenotifier) approach, as it satisfies the architectural requirements, simplifies testing, and highly extensible.

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

#### Processing raw deep links provided by the `NavigationNotifier` into page-specific deep links

The code snippet below demonstrates the raw deep link parsing process.

```dart
/// An abstraction for page-specific deep links.
abstract class PageDeepLinks {}

/// A class that represents the Dashboard page-specific deep links.
class DashboardPageDeepLinks implements PageDeepLinks {

  // Other fields, constructor here...

  /// Creates a new instance of the [DashboardPageDeepLinks] from the given
  /// [map].
  factory DashboardPageDeepLinks.fromMap(
    Map<String, dynamic> map,
  ) {
    final selectedProjectGroup = map['selected_project_group'];

    return DashboardPageDeepLinks(selectedProjectGroup: selectedProjectGroup);
  }
}

/// A [ChangeNotifier] that provides an ability to manage the application's deep links.
class DeepLinksNotifier extends ChangeNotifier {

  // Other fields, constructor here...

  /// A current value of the deep link in the application.
  PageDeepLinks _currentDeepLinks;

  /// Handles the given [routeConfiguration] and updates the [PageDeepLinks] value.
  void handleRouteConfiguration(RouteConfiguration routeConfiguration) {
    // If the deep links are associated with a Dashboard page
    if(routeConfiguration.name = RouteName.dashboard) {
      final routeParameters = routeConfiguration.routeParameters;

      _currentDeepLinks = DashboardPageDeepLinks.fromMap(routeParameters);
      notifyListeners();
    }
    // Other routes handling...
  }
}
```


#### Providing page-specific deep links to the corresponding page ChangeNotifiers

The code snippet below demonstrates an example of creating a connection between the `DeepLinksNotifier` and `SomePageNotifier` using a listener.

```dart
/// An abstract class that represents a [ChangeNotifier] of a specific page.
abstract class PageNotifier extends ChangeNotifier {
  /// Provides the current state of deep links associated with this page.
  PageDeepLinks get pageDeepLinks;

  /// Handles the deep links updates represented by the given
  /// [pageDeepLinks].
  void handleDeepLinkUpdates(PageDeepLinks pageDeepLinks);
}

/// A listener that triggers the [SomePageNotifier.handleDeepLinkUpdates] on [DeepLinksNotifier.currentDeepLinks]
/// updates.
void deepLinksNotifierListener() {
  final currentDeepLinks = deepLinksNotifier.currentDeepLinks;

  somePageNotifier.handleDeepLinkUpdates(currentDeepLinks);
}
```

#### Handling page-specific deep links updates provided by page ChangeNotifiers

The code snippet below demonstrates the connection between `SomePageNotifier` and `DeepLinksNotifier` about `PageDeepLink`'s updates using a listener function.
 
```dart
/// A listener that triggers the [DeepLinksNotifier.handlePageDeepLinks] on [SomePageNotifier.pageDeepLinks]
/// updates.
void somePageNotifierListener() {
  final pageDeepLinks = somePageNotifier.pageDeepLinks;

  deepLinksNotifier.handlePageDeepLinks(pageDeepLinks);
}
```

#### Providing deep links' updates to the `NavigationNotifier`

The following code snippet demonstrates the connection between the `DeepLinksNotifier` and  `NavigationNotifier` to save the deep links in the URL using the listener function.

```dart
/// A listener that triggers the [NavigationNotifier.saveDeepLinks] on [DeepLinksNotifier.currentDeepLinks]
/// updates.
void deepLinksNotifierListener() {
  final currentDeepLinks = deepLinksNotifier.currentDeepLinks;

  navigationNotifier.saveDeepLinks(currentDeepLinks);
}
```

### System modeling
> Create an abstract model of the system/feature.

Let’s consider that a `DeepLinksDispatcher`  is a widget that is responsible for establishing the connections between the `NavigationNotifier`, `DeepLinksNotifier` and the specific page `ChangeNotifier`s.

The following sequence diagrams illustrate how the main requirements of the feature may work in the system:

- Parsing deep links
  ![Applying deep links sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/dashboard/raw/master/metrics/web/docs/analysis/deep_links/diagrams/applying_deep_links_sequence_diagram.puml)

- Saving deep links
  ![Saving deep links sequence diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://github.com/platform-platform/dashboard/raw/master/metrics/web/docs/analysis/deep_links/diagrams/saving_deep_links_sequence_diagram.puml)
