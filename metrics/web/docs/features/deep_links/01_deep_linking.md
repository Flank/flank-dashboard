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
    - [System modeling](#system-modeling)

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
- Updating the URL and the `query parameters` in response to any events.

Since `Navigator 2.0` provides the navigation system that allows performing the actions listed above, and the Metrics Web application uses `Navigator 2.0`, it is possible to implement the `Deep Linking` feature in the Metrics Web application.

### Requirements
> Define requirements and make sure that they are complete.

The `Deep Linking` feature must satisfy the following requirements:
- Possibility to handle deep links and restore the application's state using them;
- Possibility to update the URL and the query parameters without changing the current browser history;
- Possibility to restore deep links/application state in response to app-specific events (`back`, `home` button pressed, etc.);

### Prerequisites
Before deep-diving into deep linking feature analysis, make sure to get familiar with the Flutter new navigation system ([Navigator 2.0](https://flutter.dev/docs/release/breaking-changes/route-navigator-refactoring)) which is [used in the Metrics Web application](https://github.com/Flank/flank-dashboard/blob/master/metrics/web/docs/features/navigation/01_navigation_design.md). The understanding of the Navigator 2.0 approach is important for the understanding deep linking approaches.

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

Let's review the pros and cons of this approach:

Pros:
- Provides ready-to-use implementation out of the box, including deep linking, nested navigation, and many other features.

Cons:
- May require code generation (e.g. as in [`auto_route`](https://pub.dev/packages/auto_route) package);
- Requires the navigation system reintegration - meaning that we must use the 3-rd party `RouteInformationParser`s and `RouterDelegate`s.

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

![Custom approach diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/update_deep_links_analysis/metrics/web/docs/features/deep_links/diagrams/custom_approach_component_diagram.puml)

### Prototyping
> Create a simple prototype to confirm that implementing this feature is possible.

As we've described in the [`requirements`](#requirements) section, we must be able to perform the following actions to implement the `Deep Linking` feature:
- Parsing the `query parameters` from the URL;
- Updating the URL and the `query parameters` in response to any events.

The next code snippets demonstrate how we can perform the listed required actions:

- Parsing the query parameters from the URL:
```dart
final url = 'https://some-website/page?queryParameter=someParameter';

final uri = Uri.parse(url);

print(uri.queryParameters); // {queryParameter : someParameter)
```

- Updating the URL in the browser (using the [`universal_html`](https://pub.dev/packages/universal_html) package without changing its history):
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

![Deep links integration diagram](http://www.plantuml.com/plantuml/proxy?cache=no&fmt=svg&src=https://raw.githubusercontent.com/Flank/flank-dashboard/update_deep_links_analysis/metrics/web/docs/features/deep_links/diagrams/deep_links_integration_component_diagram.puml)
