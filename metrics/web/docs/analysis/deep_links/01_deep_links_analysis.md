# Deep Links Approaches Analysis
> Feature description / User story.

As a User, I want to pass direct links to project and/or project groups, so that other users can navigate easier.

# Analysis
> Describe the general analysis approach.

During the analysis stage, we are going to investigate the implementation approaches for deep linking in the Metrics Web application and choose the most suitable one for us.

## Feasibility study
> A preliminary study of the feasibility of implementing this feature.

Since the Flutter [supports deep links](https://flutter.dev/docs/development/ui/navigation/deep-linking) we can implement the deep linking in the Metrics Web application.

## Requirements
> Define requirements and make sure that they are complete.

- Possibility to handle deep links and restore the application's state using them;
- Possibility to generate deep links and save the application state in response to UI events (filtering, dropdown selections, searching, etc.);
- Extensible and testable implementation approach.

## Landscape
> Look for existing solutions in the area.

We need to decide with the approaches for the following concepts:
- [Deep Linking Approach](#deep-linking-approach) - meaning how to save the application state in the URLs.
- [Deep Links Integration Approach](#deep-links-integration-approach) - meaning how to integrate deep links to the Metrics Web Application.

Let's review them in the next sections.

### Deep Linking approach
There are two main deep linking approaches: `query parameters` and `path segments`.   
Let's consider a problem that we are to solve using deep links. For example, we need to save a project name filter's state in a deep link. Let's compare the listed approaches for solving this problem:

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
- As Dart provides a List-based API for working with path segments, parsing of the deep links depends on the order of path segments, which makes parsing deep links based on path segments much harder. The following code snippet demonstrates the path segments parsing in Dart:
```dart
  final url = Uri.parse("https://domain.com/foo/bar/baz");

  print(url.path); // /foo/bar/baz
  print(url.pathSegments); // [foo, bar, baz]
```
- Less flexible approach - meaning that it is hard to combine multiple searching, filtering, or grouping arguments.

### Conclusion
According to the [requirements](#requirements) listed above, and the comparison of the [`query parameters`](#query-parameters) and the [`path segments`](#path-segments), we choose to use the [`query parameters`](#query-parameters) approach for deep linking.

### Deep Links Integration Approach
There are two main approaches for the integration of the deep links to the Metrics Web Application:
- [Deep Links Integration Using DeepLinksNotifier](#deep-links-integration-using-deeplinksnotifier).
- [Deep Links Integration Using Route Parameters](#deep-links-integration-using-route-parameters).

Note, as the Metrics Web Application uses `Navigator 2.0` (consider this [document](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/features/navigation/01_navigation_design.md) describing `Navigator 2.0` integration in the Metrics Web Application) for navigation, both approaches are based on the features of the `Navigator 2.0`, thus they differ only in the way the deep links are applied to the Metrics Web Application components.

Now, let's review the listed approaches.

### Deep Links Integration Using DeepLinksNotifier
The main idea of the approach is to introduce a new `ChangeNotifier`, let's call it a `DeepLinksNotifier`.
The `DeepLinksNotifier` is responsible for:
- Processing raw deep links provided by the `NavigationNotifier` into page-specific deep links;
- Providing page-specific deep links to corresponding page presenters to handle them;
- Handling page-specific deep links updates provided by page presenters;
- Providing deep links' updates to the `NavigationNotifier`, which updates the browser history state to save a deep link update in a URL.

#### Pros
- Well segregated responsibility between components; 
- Extensible approach - meaning that we can easily add new page-specific deep links or extend them;
- Easy to test, because of the responsibility segregation.

#### Cons
- Requires implementing new `ChangeNotifier`s and extending existing ones.

### Deep Links Integration Using Route Parameters
The main idea of this approach is to dispatch deep links using page parameters, which are then handled by the pages. For example, if a `DashboardPage` includes a project group selection menu, we can add a `projectGroupName` parameter to a `DashboardPage`, which is then handled by the page itself.

However, according to the ["UI elements"](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/02_presentation_layer_architecture.md#ui-elements) section of the ["Metrics Web Presentation Layer"](https://github.com/platform-platform/monorepo/blob/master/metrics/web/docs/02_presentation_layer_architecture.md) document, a `Page` is a widget, whose responsibility is a proper Metrics widgets combining, thus, handling any parameters is out of scope of a `Page` widget's responsibilities.

#### Pros
- Does not require implementing new or extending existing `ChangeNotifier`s.

#### Cons
- Does not satisfy the existing architecture requirements;
- Harder to test;
- Adding parameters handling may increase the `page` widgets size, and decrease the code readability.

### Conclusion
According to the comparison above, we choose the [Deep Links Integration Using DeepLinksNotifier](#deep-links-integration-using-deeplinksnotifier) approach, as it satisfies the architectural requirements, simplifies testing, and highly extensible.

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

#### Processing raw deep links provided by the `NavigationNotifier` into page-specific deep links
<details>
  <summary>Code snippet</summary>

```dart
/// An abstraction for page-specific deep links.
abstract class PageDeepLinks {}

/// A class that represents the Dashboard page specific deep links.
class DashboardPageDeepLinks implements PageDeepLinks {

  // Other fields, constructor here...
  
  /// Creates a new instance of the [DashboardPageDeepLinks] from the given
  /// [routeParameters].
  factory DashboardPageDeepLinks.fromRouteParameters(
    Map<String, dynamic> routeParameters,
  ) {
    final selectedProjectGroup = routeParameters['selected_project_group'];
    
    return DashboardPageDeepLinks(selectedProjectGroup: selectedProjectGroup);
  }
}

/// A [ChangeNotifier] that provides an ability to manage application's deep links.
class DeepLinksNotifier extends ChangeNotifier {
  
  // Other fields, constructor here...
  
  /// A current value of the deep link in the application.
  PageDeepLinks _currrentDeepLinks;
  
  /// Handles the given [routeConfiguration] and updates the [PageDeepLinks] value.
  void handleRouteConfiguration(RouteConfiguration routeConfiguration) {
    // If the deep links are associated with a Dashboard page
    if(routeConfiguration.name = RouteName.dashboard) {
      final routeParameters = routeConfiguration.routeParameters;

      _currentDeepLinks = DashboardPageDeepLinks.fromRouteParameters(routeParameters);
      notifyListeners();
    }
    // Other routes handling...
  }
}
```

</details>

#### Providing page-specific deep links to corresponding page presenters
<details>
  <summary>Code snippet</summary>

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

</details>

#### Handling page-specific deep links updates provided by page presenters
<details>
  <summary>Code snippet</summary>

```dart
/// A listener that triggers the [DeepLinksNotifier.handlePageDeepLinks] on [SomePageNotifier.pageDeepLinks]
/// updates.
void somePageNotifierListener() {
  final pageDeepLinks = somePageNotifier.pageDeepLinks;

  deepLinksNotifier.handlePageDeepLinks(pageDeepLinks);
}
```

</details>

#### Providing deep links' updates to the `NavigationNotifier`
<details>
  <summary>Code snippet</summary>

```dart
/// A listener that triggers the [NavigationNotifier.saveDeepLinks] on [DeepLinksNotifier.currentDeepLinks]
/// updates.
void deepLinksNotifierListener() {
  final currentDeepLinks = deepLinksNotifier.currentDeepLinks;

  navigationNotifier.saveDeepLinks(currentDeepLinks);
}
```
</details>

### System modeling
> Create an abstract model of the system/feature.
